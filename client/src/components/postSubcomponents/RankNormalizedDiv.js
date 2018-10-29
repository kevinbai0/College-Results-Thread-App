import React from "react";
import NormalizedIndicator from "../subcomponents/NormalizedIndicator";

const RankNormalizedDiv = ({rank, hover, unhover}) => {
    let rankStr = "N/A";
    if (rank.rankInClass > -1 && rank.classSize > -1) rankStr = rank.rankInClass + " / " + rank.classSize;
    else if (rank.rankInClass > -1) rankStr = "#" + rank.rankInClass;
    else if (rank.percent > -1) rankStr = rank.percent + "%";

    return <div className="rank-section">
        <div className="body-header">Rank</div>
        <div className="body-content">{rankStr}</div>
        <NormalizedIndicator isNormalized={true} hover={hover} unhover={unhover}/>
    </div>
}

export default RankNormalizedDiv;