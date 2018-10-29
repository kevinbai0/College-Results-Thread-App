import React from "react";
import Select from "react-select";

const Filter = ({queryKey, title, options, onFilterChange}) => (
    <div className="filter">
        <div className="filter-title">{title}</div>
        <Select className="filter-select" onChange={(result) => onFilterChange(queryKey, result.value)}classNamePrefix="filter-select" options={options}/>
    </div>
)

export default Filter;