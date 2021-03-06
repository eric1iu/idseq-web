import { map, keyBy, mapValues, every, pick, sum, difference } from "lodash/fp";

import { markSampleUploaded, uploadFileToUrlWithRetries } from "~/api";

import { putWithCSRF, postWithCSRF } from "./core";

export const bulkUploadBasespace = ({ samples, metadata }) =>
  bulkUploadWithMetadata(samples, metadata);

export const bulkUploadRemote = ({ samples, metadata }) =>
  bulkUploadWithMetadata(samples, metadata);

export const bulkUploadLocalWithMetadata = async ({
  samples,
  metadata,
  callbacks = {
    onCreateSamplesError: null,
    onSampleUploadProgress: null,
    onSampleUploadError: null,
    onSampleUploadSuccess: null,
    onMarkSampleUploadedError: null,
  },
}) => {
  // Store the upload progress of file names, so we can track when
  // everything is done.
  const fileNamesToProgress = {};
  const markedUploaded = {};
  const sampleNamesToFiles = mapValues("files", keyBy("name", samples));

  // Only upload these fields from the sample.
  const processedSamples = map(
    pick([
      "alignment_config_name",
      "client",
      "dag_vars",
      "do_not_process",
      "host_genome_id",
      "input_files_attributes",
      "max_input_fragments",
      "name",
      "pipeline_branch",
      "pipeline_execution_strategy",
      "project_id",
      "s3_preload_result_path",
      "subsample",
      "use_taxon_whitelist",
      "wetlab_protocol",
      "workflows",
    ]),
    samples
  );

  // This function needs access to fileNamesToProgress.
  const onFileUploadSuccess = async (sample, sampleId) => {
    const sampleFiles = sampleNamesToFiles[sample.name];
    // If every file for this sample is uploaded, mark it as uploaded.
    if (
      !markedUploaded[sample.name] &&
      every(file => fileNamesToProgress[file.name] === 1, sampleFiles)
    ) {
      markedUploaded[sample.name] = true;
      try {
        await markSampleUploaded(sampleId);

        callbacks.onSampleUploadSuccess &&
          callbacks.onSampleUploadSuccess(sample);
      } catch (_) {
        callbacks.onMarkSampleUploadedError &&
          callbacks.onMarkSampleUploadedError(sample.name);
      }
    }
  };

  // Calculate the current sample upload percentage.
  const getSampleUploadPercentage = sample => {
    const sampleFiles = sample.input_files.map(inputFileAttributes => {
      return sampleNamesToFiles[sample.name][inputFileAttributes.name];
    });

    const sampleFileUploadProgress = map(
      file => ({
        percentage: fileNamesToProgress[file.name] || null,
        size: file.size,
      }),
      sampleFiles
    );

    const uploadedSize = sum(
      map(
        progress => (progress.percentage || 0) * progress.size,
        sampleFileUploadProgress
      )
    );

    const totalSize = sum(
      map(progress => progress.size, sampleFileUploadProgress)
    );

    return uploadedSize / totalSize;
  };

  let response;

  try {
    response = await bulkUploadWithMetadata(processedSamples, metadata);
  } catch (e) {
    callbacks.onCreateSamplesError &&
      callbacks.onCreateSamplesError([e], map("name", samples));
    return;
  }

  // It's possible that a subset of samples errored out, but other ones can still be uploaded.
  if (response.errors.length > 0) {
    callbacks.onCreateSamplesError &&
      callbacks.onCreateSamplesError(
        response.errors,
        response.errored_sample_names
      );
  }

  // After successful sample creation, upload each sample's input files to the presigned URLs
  response.samples.forEach(sample => {
    const files = sampleNamesToFiles[sample.name];

    // Start pinging server to monitor uploads server-side
    const interval = startUploadHeartbeat(sample.id);

    sample.input_files.map(inputFileAttributes => {
      const file = files[inputFileAttributes.name];
      const url = inputFileAttributes.presigned_url;

      uploadFileToUrlWithRetries(file, url, {
        onUploadProgress: e => {
          const percent = e.loaded / e.total;
          fileNamesToProgress[file.name] = percent;

          if (callbacks.onSampleUploadProgress) {
            const uploadedPercentage = getSampleUploadPercentage(sample);

            callbacks.onSampleUploadProgress(sample, uploadedPercentage);
          }
        },
        onSuccess: () => {
          fileNamesToProgress[file.name] = 1;
          onFileUploadSuccess(sample, sample.id);
          clearInterval(interval);
        },
        onError: error => {
          callbacks.onSampleUploadError &&
            callbacks.onSampleUploadError(sample, error);
          clearInterval(interval);
        },
      });
    });
  });
};

// Bulk-upload samples (both local and remote), with metadata.
const bulkUploadWithMetadata = async (samples, metadata) => {
  const response = await postWithCSRF(
    `/samples/bulk_upload_with_metadata.json`,
    {
      samples,
      metadata,
      client: "web",
    }
  );

  // Add the errored sample names to the response.
  if (response.errors.length > 0) {
    const erroredSampleNames = difference(
      map("name", samples),
      map("name", response.samples)
    );

    return {
      ...response,
      errored_sample_names: erroredSampleNames,
    };
  }

  return response;
};

// Local uploads go directly from the browser to S3, so we don't know if an upload was interrupted.
// Ping the heartbeat endpoint periodically to say the browser is actively uploading this sample.
export const startUploadHeartbeat = async sampleId => {
  const sendHeartbeat = () => {
    putWithCSRF(`/samples/${sampleId}/upload_heartbeat.json`).catch(() =>
      // eslint-disable-next-line no-console
      console.error("Can't connect to IDseq server.")
    );
  };
  sendHeartbeat(); // Send first heartbeat immediately so we know it is working
  const interval = 60000; // 60 sec
  return setInterval(sendHeartbeat, interval);
};
