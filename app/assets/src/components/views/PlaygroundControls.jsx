import CompareButton from "../ui/controls/buttons/CompareButton";
import DownloadButton from "../ui/controls/buttons/DownloadButton";
import Dropdown from "../ui/controls/dropdowns/Dropdown";
import ButtonDropdown from "../ui/controls/dropdowns/ButtonDropdown";
import MultipleDropdown from "../ui/controls/dropdowns/MultipleDropdown";
import ThresholdFilterDropdown from "../ui/controls/dropdowns/ThresholdFilterDropdown";
import PrimaryButton from "../ui/controls/buttons/PrimaryButton";
import PropTypes from "prop-types";
import React from "react";
import SecondaryButton from "../ui/controls/buttons/SecondaryButton";
import Slider from "../ui/controls/Slider";

class PlaygroundControls extends React.Component {
  constructor(props) {
    super(props);
    this.thresholdOptions = this.props.thresholdFilters;
    this.dropdownOptions = [
      { text: "Option 1", value: 0 },
      { text: "option 2", value: 1 },
      { text: "Option 3", value: 2 }
    ];

    this.state = {
      event: ""
    };
  }

  render() {
    return (
      <div className="playground">
        <div className="playground-grid">
          <ComponentCard
            title="Primary Button"
            width={3}
            components={[
              <PrimaryButton
                key={0}
                text="Submit"
                onClick={() => this.setState({ event: "PrimaryButton:Click" })}
              />,
              <PrimaryButton
                key={1}
                text="Submit"
                disabled
                onClick={() => this.setState({ event: "PrimaryButton:Click" })}
              />
            ]}
          />
          <ComponentCard
            title="Secondary Button"
            width={3}
            components={[
              <SecondaryButton
                key={0}
                text="Submit"
                onClick={() =>
                  this.setState({ event: "SecondaryButton:Click" })
                }
              />,
              <SecondaryButton
                key={1}
                text="Submit"
                disabled
                onClick={() =>
                  this.setState({ event: "SecondaryButton:Click" })
                }
              />
            ]}
          />
          <ComponentCard
            title="Icon Button"
            width={3}
            components={[
              <CompareButton
                key={0}
                onClick={() => this.setState({ event: "CompareButton:Click" })}
              />,
              <CompareButton
                key={1}
                disabled
                onClick={() =>
                  this.setState({
                    event: "CompareButton:Click: should not show up!"
                  })
                }
              />
            ]}
          />
          <ComponentCard
            title="Button Dropdown"
            width={3}
            components={[
              <ButtonDropdown
                primary
                key={0}
                fluid
                options={this.dropdownOptions}
                text="Download"
                onClick={option =>
                  this.setState({ event: "DropdownButton:Clicked", option })
                }
              />,
              <ButtonDropdown
                primary
                key={1}
                fluid
                disabled
                options={this.dropdownOptions}
                text="Download"
                onClick={option =>
                  this.setState({ event: "DropdownButton:Change", option })
                }
              />
            ]}
          />
          <ComponentCard
            title="Download Dropdown"
            width={3}
            components={[
              <DownloadButton
                key={0}
                fluid
                options={this.dropdownOptions}
                text="Download"
                onClick={option =>
                  this.setState({ event: "DropdownButton:Clicked", option })
                }
              />,
              <DownloadButton
                key={1}
                fluid
                disabled
                options={this.dropdownOptions}
                text="Download"
                onClick={option =>
                  this.setState({ event: "DropdownButton:Clicked", option })
                }
              />
            ]}
          />
          <ComponentCard
            title="Threshold Filter Dropdown"
            width={5}
            components={[
              <ThresholdFilterDropdown
                key={0}
                options={this.thresholdOptions}
                onApply={vars => {
                  this.setState({
                    event: "ThresholdFilterDropdown:Apply",
                    vars
                  });
                }}
              />,
              <ThresholdFilterDropdown
                key={1}
                options={this.thresholdOptions}
                disabled
                onApply={vars => {
                  this.setState({
                    event: "ThresholdFilterDropdown:Apply",
                    vars
                  });
                }}
              />
            ]}
          />
          <ComponentCard
            title="Dropdown"
            width={4}
            components={[
              <Dropdown
                key={0}
                fluid
                options={this.dropdownOptions}
                label="Option:"
                onChange={() => this.setState({ event: "Dropdown:Change" })}
              />,
              <Dropdown
                key={1}
                fluid
                disabled
                options={this.dropdownOptions}
                label="Option:"
                onChange={() => this.setState({ event: "Dropdown:Change" })}
              />
            ]}
          />
          <ComponentCard
            title="Multiple Option Dropdown"
            width={4}
            components={[
              <MultipleDropdown
                key={0}
                fluid
                options={this.dropdownOptions}
                label="Options: "
                onChange={() =>
                  this.setState({ event: "MultipleDropdown:Change" })
                }
              />,
              <MultipleDropdown
                key={1}
                fluid
                disabled
                options={this.dropdownOptions}
                label="Options: "
                onChange={() =>
                  this.setState({ event: "MultipleDropdown:Change" })
                }
              />
            ]}
          />
          <ComponentCard
            title="Slider"
            width={4}
            components={[
              <Slider
                key={0}
                options={this.dropdownOptions}
                label="Slider: "
                onChange={() => this.setState({ event: "Slider:Change" })}
                onAfterChange={() =>
                  this.setState({ event: "Slider:onAfterChange" })
                }
                min={0}
                max={100}
                value={20}
              />,
              <Slider
                key={1}
                disabled
                options={this.dropdownOptions}
                label="Slider: "
                onChange={() => this.setState({ event: "Slider:Change" })}
                onAfterChange={() =>
                  this.setState({ event: "Slider:onAfterChange" })
                }
                min={0}
                max={100}
                value={20}
              />
            ]}
          />
        </div>
        <div className="playground-console">
          <span className="playground-console-label">Last Event:</span>
          {this.state.event || "N/A"}
        </div>
      </div>
    );
  }
}

PlaygroundControls.propTypes = {
  thresholdFilters: PropTypes.object
};

const ComponentCard = ({ title, components, width }) => {
  return (
    <div
      className="component-card"
      style={{ gridColumn: `auto / span ${width}` }}
    >
      <div className="title">{title}</div>
      {components.map((component, idx) => (
        <div key={idx} className="component">
          {component}
        </div>
      ))}
    </div>
  );
};

ComponentCard.propTypes = {
  components: PropTypes.arrayOf(PropTypes.node),
  title: PropTypes.string,
  width: PropTypes.number
};

export default PlaygroundControls;