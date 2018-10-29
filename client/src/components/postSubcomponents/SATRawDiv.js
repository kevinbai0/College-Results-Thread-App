import React from "react";
import NormalizedIndicator from "../subcomponents/NormalizedIndicator";

const SATRawDiv = ({sat, hover, unhover}) => 
    <div className="sat-raw-section">
        <div className="body-header">SAT</div>
        <div className="body-content restrict-lines">{sat}</div>
        <NormalizedIndicator isNormalized={false} hover={hover} unhover={unhover}/>
    </div>

export default SATRawDiv;