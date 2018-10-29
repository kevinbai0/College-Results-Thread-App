import React, {Component} from "react";

import DecisionNormalizedDiv from "./postSubcomponents/DecisionNormalizedDiv";
import DecisionRawDiv from "./postSubcomponents/DecisionRawDiv";
import SATNormalizedDiv from "./postSubcomponents/SATNormalizedDiv";
import SATRawDiv from "./postSubcomponents/SATRawDiv";
import ACTNormalizedDiv from "./postSubcomponents/ACTNormalizedDiv";
import ACTRawDiv from "./postSubcomponents/ACTRawDiv";
import GPADiv from "./postSubcomponents/GPADiv";
import RankNormalizedDiv from "./postSubcomponents/RankNormalizedDiv";
import RankRawDiv from "./postSubcomponents/RankRawDiv";
import ProfileDiv from "./postSubcomponents/ProfileDiv";

//const EXPANDED = "Expanded";
const CONDENSED = "Condensed";
class Post extends Component {
    constructor(props) {
        super(props);
        this.state = {
            mode: CONDENSED,
        }
        this.iconHover = this.iconHover.bind(this);
        this.iconUnhover = this.iconUnhover.bind(this);
    }

    render() {
        let raw = this.props.raw;
        let normalized = this.props.normalized;
        let components = this.getComponentsFromData(raw, normalized);
        // determine raw or normalized components based on data

        if (this.state.mode === CONDENSED) {
            return  (
                <CondensedPost 
                    components={components} 
                />
            );
        }

        return <ExpandedPost components={components}/>;
    }

    getComponentsFromData = (raw, normalized) => {
        return {
            "commentId": normalized["commentId"],
            "profileLink": <a className="button-link" href={normalized.commentLink}>View full profile</a>,
            "decisionDiv": normalized.decision.length > 0 ? 
                <DecisionNormalizedDiv decision={normalized.decision} /> :
                <DecisionRawDiv decision={raw.decision} />,
            "schoolDiv": 
                <div className="school-div decision-header">School: {normalized.school}</div>,
            "satDiv": normalized["sat (combined)"] > -1 ?
                <SATNormalizedDiv 
                    rw={normalized["sat (R/W)"]}
                    math={normalized["sat (math)"]}
                    combined={normalized["sat (combined)"]}
                    hover={(mousePos) => this.iconHover(mousePos, raw["sat1"])}
                    unhover={() => this.iconUnhover()}
                /> :
                <SATRawDiv 
                    sat={raw.sat1}
                    hover={(mousePos) => this.iconHover(mousePos, raw["sat1"])}
                    unhover={() => this.iconUnhover()}
                />,
            "actDiv": normalized["act (combined)"] > -1 ? 
                <ACTNormalizedDiv 
                    rd={normalized["act (reading)"]}
                    wr={normalized["act (english)"]}
                    math={normalized["act (math)"]}
                    science={normalized["act (science)"]}
                    comb={normalized["act (combined)"]}
                    hover={(mousePos) => this.iconHover(mousePos, raw["act"])}
                    unhover={() => this.iconUnhover()}
                /> :
                <ACTRawDiv 
                    score={raw.act}
                    hover={(mousePos) => this.iconHover(mousePos, raw["act"])}
                    unhover={() => this.iconUnhover()}
                />,
            "unweightedGPADiv": 
                <GPADiv
                    title="Unweighted GPA"
                    result={normalized["unweightedGPA"] > -1 ? normalized["unweightedGPA"] : raw["unweightedGPA"]}
                    normalized={normalized["unweightedGPA"] > -1}
                    hover={(mousePos) => this.iconHover(mousePos, raw["unweightedGPA"])}
                    unhover={() => this.iconUnhover()}
                />,
            "weightedGPADiv": 
                <GPADiv 
                    title="Weighted GPA"
                    result={normalized["weightedGPA"] > -1 ? normalized["weightedGPA"] : raw["weightedGPA"]}
                    normalized={normalized["weightedGPA"] > -1}
                    hover={(mousePos) => this.iconHover(mousePos, raw["weightedGPA"])}
                    unhover={() => this.iconUnhover()}
                />,
            "rankDiv": (normalized.rank.rankInClass > -1 || normalized.rank.classSize > -1 || normalized.rank.percent > -1) ?
                <RankNormalizedDiv 
                    rank={normalized["rank"]}
                    hover={(mousePos) => this.iconHover(mousePos, raw["rank"])}
                    unhover={() => this.iconUnhover()}
                /> : 
                <RankRawDiv 
                    rank={raw["rank"]}
                    hover={(mousePos) => this.iconHover(mousePos, raw["rank"])}
                    unhover={() => this.iconUnhover()}
                />,
            "genderDiv": 
                <ProfileDiv
                    title="Gender"
                    value={normalized["gender"].length > 0 ? normalized["gender"] : raw["gender"]}
                    normalized={normalized["gender"].length > 0}
                    hover={(mousePos) => this.iconHover(mousePos, raw["gender"])}
                    unhover={() => this.iconUnhover()}
                />,
            "ethnicityDiv": 
                <ProfileDiv
                    title="Ethnicity"
                    value={normalized["ethnicity"].length > 0 ? normalized["ethnicity"] : raw["ethnicity"]}
                    normalized={normalized["ethnicity"].length > 0}
                    hover={(mousePos) => this.iconHover(mousePos, raw["ethnicity"])}
                    unhover={() => this.iconUnhover()}
                />,
            "countryDiv": 
                <ProfileDiv
                    title="Country"
                    value={normalized["country"].length > 0 ? normalized["country"] : raw["country"]}
                    normalized={normalized["country"].length > 0}
                    hover={(mousePos) => this.iconHover(mousePos, raw["country"])}
                    unhover={() => this.iconUnhover()}
                />,
            "stateDiv": 
                <ProfileDiv
                    title="State"
                    value={normalized["state"].length > 0 ? normalized["state"] : raw["state"]}
                    normalized={normalized["state"].length > 0}
                    hover={(mousePos) => this.iconHover(mousePos, raw["state"])}
                    unhover={() => this.iconUnhover()}
                />,
            "schoolTypeDiv": 
                <ProfileDiv 
                    title="School Type"
                    value={normalized["schoolType"].length > 0 ? normalized["schoolType"] : raw["schoolType"]}
                    normalized={normalized["schoolType"].length > 0}
                    hover={(mousePos) => this.iconHover(mousePos, raw["schoolType"])}
                    unhover={() => this.iconUnhover()}
                />,
            "financialAidDiv":
                <ProfileDiv 
                    title="Financial Aid?"
                    value={normalized["appliedForFinancialAid"] !== undefined ? normalized["appliedForFinancialAid"] : raw["appliedForFinancialAid"]}
                    normalized={normalized["appliedForFinancialAid"] !== undefined}
                    hover={(mousePos) => this.iconHover(mousePos, raw["appliedForFinancialAid"])}
                    unhover={() => this.iconUnhover()}
                />
        }
    }

    iconHover = (mousePos, hoverText) => {
        this.props.updateFloatingContent(mousePos, hoverText);
    }
    iconUnhover = () => {
        this.props.updateFloatingContent({x: 0, y: 0}, "");

    }
}

const CondensedPost = ({components}) =>
    <div className="applicant-post">
        <div className="stats-section">
            <div className="applicant-info-header">
                {components.schoolDiv}
                {components.decisionDiv}
            </div>
            <div className="column-1">
                {components.satDiv}
                {components.actDiv}
            </div>
            <div className="column-2">
                {components.unweightedGPADiv}
                {components.weightedGPADiv}
                {components.rankDiv}
            </div>
        </div>
        <div className="general-section">
            {components.profileLink}
            <div className="general-section-content">
                {components.genderDiv}
                {components.ethnicityDiv}
                {components.countryDiv}
                {components.stateDiv}
                {components.schoolTypeDiv}
                {components.financialAidDiv}
            </div>
        </div>
    </div>


const ExpandedPost = ({components}) =>
    <div>
        
    </div>


export default Post;