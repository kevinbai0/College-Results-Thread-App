import React from "react";

const DecisionRawDiv = ({decision}) => {
    let style = "decision-unknown"
    if (decision.includes("Accepted")) style = "decision-accepted";
    else if (decision.includes("Rejected")) style = "decision-rejected";
    else if (decision.includes("Deferred")) style = "decision-deferred";
     
return <div className={"decision-header " + style}>Decision: {decision}<span className="normalized-icon-false"></span>
</div>;
}

export default DecisionRawDiv;