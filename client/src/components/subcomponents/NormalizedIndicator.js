import React from "react";
import anime from "animejs";

const NormalizedIndicator = ({isNormalized, hover, unhover}) => 
    <span 
        className={isNormalized ? "normalized-icon-true" : "normalized-icon-false"}
        onMouseOver={(e) => hoverHandler(hover, {x: e.clientX, y: e.clientY + window.scrollY})}
        onMouseOut={(e) => unhover()}
    ></span>

const hoverHandler = (hoverFunction, hoverHandler) => {
    hoverFunction(hoverHandler);
}

export default NormalizedIndicator