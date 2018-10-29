import React from "react";
import NormalizedIndicator from "../subcomponents/NormalizedIndicator";

const RankRawDiv = ({rank, hover, unhover}) =>  
    <div className="rank-section">
        <div className="body-header">Rank</div>
        <div className="body-content restrict-lines">{rank}</div>
        <NormalizedIndicator isNormalized={false} hover={hover} unhover={unhover}/>
    </div>

export default RankRawDiv;