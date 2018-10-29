import React from "react";

const DecisionNormalizedDiv = ({decision}) => {
    let style = "decision-unknown";
    if (decision === "Accepted") style = "decision-accepted";
    else if (decision === "Rejected") style = "decision-rejected";
    else if (decision === "Deferred") style = "decision-deferred";
    return <div className={"decision-header " + style}>Decision: {decision} <span className="normalized-icon-true"></span>
    </div>
}

export default DecisionNormalizedDiv;