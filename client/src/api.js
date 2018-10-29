const rootURL = "http://localhost:8080";

class BatchesController {
    resultsPerBatch;
    count = 0;
    ids = [];
    currentIndex = 0;
    lastIndex = 0;
    currentQuery;
    isLastBatch = () => this.currentIndex >= this.lastIndex;
    

    constructor(resultsPerBatch) {
        this.resultsPerBatch = resultsPerBatch;
    }

    setBatches = (ids) => {
        this.ids = ids;
        this.currentIndex = 0;
        this.count = ids.length;
        this.lastIndex = Math.ceil(this.count / this.resultsPerBatch);
    }

    getIdBatch = () => {
        if (this.currentIndex > this.lastIndex) return [];

        let upper;
        let lower;
        if (this.currentIndex === this.lastIndex) {
            lower = this.currentIndex * this.resultsPerBatch;
            upper = this.count - 1;
        }
        else {
            lower = this.currentIndex * this.resultsPerBatch;
            upper = (this.currentIndex + 1) * this.resultsPerBatch;
        }

        this.currentIndex += 1;
        return this.ids.slice(lower, upper);
    }
}

class Api {
    batchesController;
    constructor() {
        this.batchesController = new BatchesController(10);
    }
    search = async (queries, currentState, newQueryCallback) => {
        let applicants = (currentState && currentState.applicants) || [];
        let applicantsRaw = (currentState && currentState.applicantsRaw) || [];
        if (this.batchesController.currentQuery !== queries) {
            // new searches
            this.batchesController.currentQuery = queries;
            let _ = newQueryCallback != null ? newQueryCallback(true) : () => {};
            applicants = [];
            applicantsRaw = [];
            await this.getApplicantsIds(queries).then((ids) => this.batchesController.setBatches(ids));
        }
        // get applicants by their ids
        let idsBatch = this.batchesController.getIdBatch();
        let newApplicants = await this.getApplicantsByIds(idsBatch);
        console.log(newApplicants);
        applicants.push(...newApplicants.applicants);
        applicantsRaw.push(...newApplicants.applicantsRaw);
        return {applicants: applicants, applicantsRaw: applicantsRaw};
    }
    getApplicantsIds = (queries) => {
        return fetch(rootURL + "/api/posts" + queries).then((res) => res.json())
    }
    getApplicantsByIds = async (ids) => {
        let result;
        await fetch(rootURL + "/api/batches/getPosts", {
            method: "POST",
            body: JSON.stringify({
                ids: ids
            })
        }).then((res) => res.json()).then((json) => {
            result = json;
        });
        return result;
    }
    getSchools = (callback) => {
        fetch(rootURL + "/api/schools").then((res) => res.json())
            .then((json) => callback(json));
    }
};

let api = new Api();

export default api;