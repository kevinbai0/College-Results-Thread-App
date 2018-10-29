import React from "react";

class ExpandableSection extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            isCondensed: true
        };
    }
    render = () => (
        <div className="expandable-section">
            <div className="sub-sub-title">{this.props.title}</div>
            <div className="expand-button" onClick={this.toggleState.bind(this)}>
                Show {this.state.isCondensed ? "More" : "Less"}
            </div>
            {
                this.state.isCondensed ? "" : this.props.children
            }
        </div>
    )

    toggleState = () => {
        this.setState({isCondensed: !this.state.isCondensed})
    }
}

export default ExpandableSection;