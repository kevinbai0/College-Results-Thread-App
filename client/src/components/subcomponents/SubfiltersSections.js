import React from "react";
import ExpandableSection from "./ExpandableSection";
import Filter from "./Filter";

const SubfiltersSection = () => (
    <div className="subfilter-section">
        <div className="sub-title"> Subfilters </div>
        <ExpandableSection title="General">
            <Filter title="Ethnicity" options={[
                {value: "asian", label: "Asian"},
                {value: "white", label: "White"},
                {value: "black", label: "Black"},
                {value: "hispanic", label: "Hispanic"}
            ]}/>
            <Filter title="Country" options={[
                {value: "canada", label: "Canada"},
                {value: "usa", label: "USA"},
                {value: "mexico", label: "Mexico"},
                {value: "china", label: "China"}
            ]}/>
        </ExpandableSection>
        <ExpandableSection title="Scores">
            <Filter title="SAT (combined)" options={[
                { value: "1600", label: "1600"},
                { value: "1500+", label: "1500+"},
                { value: "1400-1500", label: "1400-1500"},
                { value: "< 1400", label: "< 1400"},
            ]}/>
            <Filter title="SAT (writing)" options={[
                { value: "800", label: "800"},
                { value: "750+", label: "750+"},
                { value: "700-750", label: "700-750"},
                { value: "< 700", label: "< 700"},
            ]}/>
            <Filter title="SAT (math)" options={[
                { value: "800", label: "800"},
                { value: "750+", label: "750+"},
                { value: "700-750", label: "700-750"},
                { value: "< 700", label: "< 700"},
            ]}/>
        </ExpandableSection>
    </div>  
)

export default SubfiltersSection;