import React from "react";
import NormalizedIndicator from "../subcomponents/NormalizedIndicator";

const ACTRawDiv = ({score, hover, unhover}) => 
    <div className="act-raw-section">
        <div className="body-header">ACT</div>
        <div className="body-content restrict-lines">{score}</div>
        <NormalizedIndicator isNormalized={false} hover={hover} unhover={unhover}/>
    </div>

export default ACTRawDiv;