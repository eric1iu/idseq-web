import React from "react";
import PropTypes from "prop-types";

import BareDropdown from "~ui/controls/dropdowns/BareDropdown";
import SecondaryButton from "~ui/controls/buttons/SecondaryButton";
import { logAnalyticsEvent } from "~/api/analytics";

import MetadataUploadModal from "./MetadataUploadModal";
import cs from "./project_upload_menu.scss";

class ProjectUploadMenu extends React.Component {
  state = {
    modalOpen: false,
  };

  goToPage = path => {
    location.href = path;
  };

  openModal = () => this.setState({ modalOpen: true });
  closeModal = () => this.setState({ modalOpen: false });

  render() {
    const { onMetadataUpdated, project } = this.props;
    const { modalOpen } = this.state;

    const trigger = (
      <div className={cs.trigger}>
        <SecondaryButton text="Upload" />
      </div>
    );

    const projectUploadItems = [
      <BareDropdown.Item
        text="Upload Samples"
        key="1"
        onClick={() => {
          logAnalyticsEvent("ProjectUploadMenu_upload-sample-btn_clicked");
          this.goToPage(`/samples/upload?projectId=${project.id}`);
        }}
      />,
      <BareDropdown.Item
        text="Upload Metadata"
        key="2"
        onClick={this.openModal}
      />,
    ];
    return (
      <div>
        <BareDropdown
          trigger={trigger}
          hideArrow
          items={projectUploadItems}
          direction="left"
        />
        {modalOpen && (
          <MetadataUploadModal
            onClose={this.closeModal}
            onComplete={onMetadataUpdated}
            project={project}
          />
        )}
      </div>
    );
  }
}

ProjectUploadMenu.propTypes = {
  onMetadataUpdated: PropTypes.func,
  project: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
  }),
};

export default ProjectUploadMenu;
