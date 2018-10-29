import React from "react";
import NormalizedIndicator from "../subcomponents/NormalizedIndicator";

const ProfileDiv = ({title, value, normalized, hover, unhover}) =>  
    <div className="post-profile-section">
        <div className="body-header white-text">{title}</div>
        <div className="body-content white-text restrict-lines">{value}</div>
        <NormalizedIndicator isNormalized={normalized} hover={hover} unhover={unhover}/>
    </div>

export default ProfileDiv;