import React from "react";
import NormalizedIndicator from "../subcomponents/NormalizedIndicator";

const GPADiv = ({title, result, normalized, hover, unhover}) => 
    <div className="gpa-section">
        <span className="body-header">{title}</span>
        <span className="body-content restrict-lines">{result}</span>
        <NormalizedIndicator isNormalized={normalized} hover={hover} unhover={unhover}/>

        
    </div>

export default GPADiv;