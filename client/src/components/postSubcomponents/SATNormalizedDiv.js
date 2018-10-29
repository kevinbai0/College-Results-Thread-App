import React from "react";
import NormalizedIndicator from "../subcomponents/NormalizedIndicator";

const SATNormalizedDiv = ({rw, math, combined, hover, unhover}) =>  
    <div className="sat-normalized-section">
        <div className="body-header">SAT</div>
        <NormalizedIndicator isNormalized={true} hover={hover} unhover={unhover}/>
        <div className="body-content">R/W</div>
        <div className="body-content">{rw > -1 ? rw : "n/a"}</div>
        <div className="body-content">Math</div>
        <div className="body-content">{math > -1 ? math : "n/a"}</div>
        <div className="body-content body-emphasis">Total</div>
        <div className="body-content body-emphasis">{combined}</div>
    </div>

export default SATNormalizedDiv;