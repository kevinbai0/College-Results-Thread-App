import React from "react";
import NormalizedIndicator from "../subcomponents/NormalizedIndicator";

const ACTNormalizedDiv = ({rd, wr, math, science, comb, hover, unhover}) => 
    <div className="act-normalized-section">
        <div className="body-header">ACT</div>
        <NormalizedIndicator isNormalized={true} hover={hover} unhover={unhover}/>
        <div className="body-content">English</div>
        <div className="body-content">{wr === -1 ? "N/A" : wr}</div>
        <div className="body-content">Math</div>
        <div className="body-content">{math === -1 ? "N/A" : math}</div>
        <div className="body-content">Reading</div>
        <div className="body-content">{rd === -1 ? "N/A" : rd}</div>
        <div className="body-content">Science</div>
        <div className="body-content">{science === -1 ? "N/A" : science}</div>
        <div className="body-content body-emphasis">Combined</div>
        <div className="body-content body-emphasis">{comb === -1 ? "N/A" : comb}</div>
    </div>

export default ACTNormalizedDiv;