import React from "react";
import Filter from "./Filter";
const MainFiltersSection = ({onFilterChange}) => (
    <div className="main-filters-section">
        <div className="sub-title">Filters</div>
        <div className="filters">
            <Filter queryKey="classYear" title="Class" onFilterChange={onFilterChange} options={[
                {value: "2022", label: "2022"},
                {value: "2021", label: "2021"},
                {value: "2020", label: "2020"}
            ]}/>
            <Filter queryKey="action" title="Action" onFilterChange={onFilterChange} options={[
                {value: "Early", label: "Early Action"},
                {value: "Regular", label: "Regular Decision"}
            ]}/>
            <Filter queryKey="decision" title="Decision" onFilterChange={onFilterChange} options={[
                {value: "All", label: "All"},
                {value: "Accepted", label: "Accepted"},
                {value: "Rejected", label: "Rejected"},
                {value: "Deferred", label: "Deferred"}
            ]}/>
        </div>
    </div>
)

export default MainFiltersSection;