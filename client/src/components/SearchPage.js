import React, { Component } from "react";
import PostsContainer from "./PostsContainer";
import MainFiltersSection from "./subcomponents/MainFiltersSection";
import SubfiltersSection from "./subcomponents/SubfiltersSections";

class SearchPage extends Component {
    render = () => (
        <div className="search-page">
            <div className="title">College Stats</div>
            <div className="search-main-section">
                <input className="search-bar" placeholder="Search School"/>
                <MainFiltersSection onFilterChange={this.updatedFilter} />
                <div className="sub-title">Posts</div>
                <PostsContainer
                    raw={this.props.raw}
                    normalized={this.props.normalized}
                    loadMore={() => this.props.refetchInformation([])}
                />
            </div>
            <SubfiltersSection />
        </div>
    )

    updatedFilter = (filterName, value) => {
        this.props.refetchInformation([
            {label: filterName, value: value}
        ])
    }
}

export default SearchPage;