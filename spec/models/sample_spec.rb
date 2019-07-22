require 'rails_helper'

describe Sample, type: :model do
  let(:file_one_name) { "sample_one.fastq.gz" }
  let(:file_one_href_content) { "https://basespace.amazonaws.com/abc123/sample_one.fastq.gz" }
  let(:file_one_href) { "https://api.basespace.illumina.com/v2/files/1" }

  let(:file_two_name) { "sample_two.fastq.gz" }
  let(:file_two_href_content) { "https://basespace.amazonaws.com/abc123/sample_two.fastq.gz" }
  let(:file_two_href) { "https://api.basespace.illumina.com/v2/files/2" }

  let(:fake_dataset_id) { "fake_dataset_id" }
  let(:fake_access_token) { "fake_access_token" }

  let(:fake_files_for_basespace_dataset_response) do
    [
      {
        name: file_one_name,
        download_path: file_one_href_content,
        source_path: file_one_href
      },
      {
        name: file_two_name,
        download_path: file_two_href_content,
        source_path: file_two_href
      }
    ]
  end

  context "#transfer_basespace_files" do
    before do
      project = create(:public_project)
      create(:alignment_config, name: AlignmentConfig::DEFAULT_NAME)
      @sample = create(:sample, project: project, status: Sample::STATUS_CREATED, input_files: [], uploaded_from_basespace: 1)
    end

    context "fetches file metadata and downloads files successfully" do
      it "updates the sample as expected and kicks off the pipeline" do
        # Set up mocks.
        expect(@sample).to receive(:files_for_basespace_dataset).exactly(1).times.and_return(fake_files_for_basespace_dataset_response)
        expect(@sample).to receive(:upload_from_basespace_to_s3).exactly(2).times.and_return(true)
        expect(@sample).to receive(:kickoff_pipeline).exactly(1).times

        @sample.transfer_basespace_files(fake_dataset_id, fake_access_token)

        expect(@sample.status).to eq(Sample::STATUS_CHECKED)
        expect(@sample.upload_error).to eq(nil)
        expect(@sample.input_files.length).to be 2

        expect(@sample.input_files[0].name).to eq(file_one_name)
        expect(@sample.input_files[0].source_type).to eq(InputFile::SOURCE_TYPE_BASESPACE)
        expect(@sample.input_files[0].source).to eq(file_one_href)
        expect(@sample.input_files[1].name).to eq(file_two_name)
        expect(@sample.input_files[1].source_type).to eq(InputFile::SOURCE_TYPE_BASESPACE)
        expect(@sample.input_files[1].source).to eq(file_two_href)
      end

      it "updates the sample as expected and kicks off the pipeline with only one input file" do
        # Set up mocks.
        expect(@sample).to receive(:files_for_basespace_dataset).exactly(1).times.and_return([
                                                                                               {
                                                                                                 name: file_one_name,
                                                                                                 download_path: file_one_href_content,
                                                                                                 source_path: file_one_href
                                                                                               }
                                                                                             ])
        expect(@sample).to receive(:upload_from_basespace_to_s3).exactly(1).times.and_return(true)
        expect(@sample).to receive(:kickoff_pipeline).exactly(1).times

        @sample.transfer_basespace_files(fake_dataset_id, fake_access_token)

        expect(@sample.status).to eq(Sample::STATUS_CHECKED)
        expect(@sample.upload_error).to eq(nil)
        expect(@sample.input_files.length).to be 1

        expect(@sample.input_files[0].name).to eq(file_one_name)
        expect(@sample.input_files[0].source_type).to eq(InputFile::SOURCE_TYPE_BASESPACE)
        expect(@sample.input_files[0].source).to eq(file_one_href)
      end

      it "does nothing if sample.status != STATUS_CREATED" do
        # Set up mocks.
        expect(@sample).to receive(:files_for_basespace_dataset).exactly(0).times
        expect(@sample).to receive(:upload_from_basespace_to_s3).exactly(0).times
        expect(@sample).to receive(:kickoff_pipeline).exactly(0).times

        @sample.status = Sample::STATUS_UPLOADED

        @sample.transfer_basespace_files(fake_dataset_id, fake_access_token)

        expect(@sample.status).to eq(Sample::STATUS_UPLOADED)
        expect(@sample.upload_error).to eq(nil)
        expect(@sample.input_files.length).to be 0
      end

      it "runs the input file checks and fails if the two basespace files have the same source" do
        expect(@sample).to receive(:files_for_basespace_dataset).exactly(1).times.and_return([
                                                                                               {
                                                                                                 name: file_one_name,
                                                                                                 download_path: file_one_href_content,
                                                                                                 source_path: file_one_href
                                                                                               },
                                                                                               {
                                                                                                 name: file_two_name,
                                                                                                 download_path: file_two_href_content,
                                                                                                 source_path: file_one_href # This is the same as the previous
                                                                                               }
                                                                                             ])

        expect(@sample).to receive(:upload_from_basespace_to_s3).exactly(2).times.and_return(2)
        expect(@sample).to receive(:kickoff_pipeline).exactly(0).times
        # Check that the proper error message is logged.
        expect(LogUtil).to receive(:log_err_and_airbrake).with(
          "SampleUploadFailedEvent: Validation failed: Input files have identical read 1 source and read 2 source"
        ).exactly(1).times

        @sample.transfer_basespace_files(fake_dataset_id, fake_access_token)

        expect(@sample.status).to eq(Sample::STATUS_CHECKED)
        expect(@sample.upload_error).to eq(Sample::UPLOAD_ERROR_BASESPACE_UPLOAD_FAILED)
        expect(@sample.input_files.length).to be 0
      end
    end

    context "cannot fetch file metadata for basespace dataset" do
      it "fails gracefully and adds a failed pipeline run" do
        # Set up mocks.
        expect(@sample).to receive(:files_for_basespace_dataset).exactly(1).times.and_return(nil)
        expect(@sample).to receive(:upload_from_basespace_to_s3).exactly(0).times
        expect(@sample).to receive(:kickoff_pipeline).exactly(0).times
        # Check that the proper error message is logged.
        expect(LogUtil).to receive(:log_err_and_airbrake).with(
          "SampleUploadFailedEvent: #{ErrorHelper::SampleUploadErrors.error_fetching_basespace_files_for_dataset(fake_dataset_id, @sample.name, @sample.id)}"
        ).exactly(1).times

        @sample.transfer_basespace_files(fake_dataset_id, fake_access_token)

        expect(@sample.status).to eq(Sample::STATUS_CHECKED)
        expect(@sample.upload_error).to eq(Sample::UPLOAD_ERROR_BASESPACE_UPLOAD_FAILED)
        expect(@sample.input_files.length).to be 0
      end
    end

    context "fetched zero files for basespace dataset" do
      it "fails gracefully and adds a failed pipeline run" do
        # Set up mocks.
        expect(@sample).to receive(:files_for_basespace_dataset).exactly(1).times.and_return([])
        expect(@sample).to receive(:upload_from_basespace_to_s3).exactly(0).times
        expect(@sample).to receive(:kickoff_pipeline).exactly(0).times
        # Check that the proper error message is logged.
        expect(LogUtil).to receive(:log_err_and_airbrake).with(
          "SampleUploadFailedEvent: #{ErrorHelper::SampleUploadErrors.no_files_in_basespace_dataset(fake_dataset_id, @sample.name, @sample.id)}"
        ).exactly(1).times

        @sample.transfer_basespace_files(fake_dataset_id, fake_access_token)

        expect(@sample.status).to eq(Sample::STATUS_CHECKED)
        expect(@sample.upload_error).to eq(Sample::UPLOAD_ERROR_BASESPACE_UPLOAD_FAILED)
        expect(@sample.input_files.length).to be 0
      end
    end

    context "cannot download basespace files" do
      it "fails gracefully and adds a failed pipeline run" do
        # Set up mocks.
        expect(@sample).to receive(:files_for_basespace_dataset).exactly(1).times.and_return(fake_files_for_basespace_dataset_response)
        expect(@sample).to receive(:upload_from_basespace_to_s3).exactly(3).times.and_return(false)
        expect(@sample).to receive(:kickoff_pipeline).exactly(0).times
        # Expect to sleep 60 after first failure, then sleep 300 on second failure.
        expect(Kernel).to receive(:sleep).with(60).ordered
        expect(Kernel).to receive(:sleep).with(300).ordered
        # Check that the proper error message is logged.
        expect(LogUtil).to receive(:log_err_and_airbrake).with(
          "SampleUploadFailedEvent: #{ErrorHelper::SampleUploadErrors.upload_from_basespace_failed(@sample.name, @sample.id, file_one_name, fake_dataset_id, 3)}"
        ).exactly(1).times

        @sample.transfer_basespace_files(fake_dataset_id, fake_access_token)

        expect(@sample.status).to eq(Sample::STATUS_CHECKED)
        expect(@sample.upload_error).to eq(Sample::UPLOAD_ERROR_BASESPACE_UPLOAD_FAILED)
        expect(@sample.input_files.length).to be 0
      end
    end
  end
end