import React, { Component } from 'react';
import SearchPage from "./components/SearchPage";
import api from "./api";

class App extends Component {
  queries = {};
  constructor(props) {
    super(props);
    this.state = {
      applicants: [],
      applicantsIds: [],
      applicantsRaw: [],
    }
  }

  async componentDidMount() {
    let result = await api.search("");
    this.setState({
      applicants: result.applicants || [],
      applicantsRaw: result.applicantsRaw || []
    });
  }
  render() {
    return (
      <div className="App">
        <SearchPage raw={this.state.applicantsRaw} normalized={this.state.applicants} refetchInformation={this.refetchInformation}/>
      </div>
    );
  }

  refetchInformation = async (queries) => {
    let finalQuery = "";
    queries.forEach((query) => this.queries[query.label] = query.value);
    
    Object.keys(this.queries).forEach((key, i) => {
      if (i !== 0) finalQuery += "&";
      else finalQuery += "?";
      finalQuery += key + "=" + this.queries[key];
    });

    let result = await api.search(finalQuery, this.state, (isNewQuery) => {
      return isNewQuery ? this.setState({
        applicants: {},
        applicantsRaw: {},
      }) : {}
    });
    this.setState({
      applicants: result.applicants || [],
      applicantsRaw: result.applicantsRaw || []
    });
  }
  mergeQueries(query1, query2) {
    let newQuery = query1;
    Object.keys(query2).forEach((key) => {
      newQuery[key] = query2[key];
    });
    return newQuery;
  }
}

export default App;
