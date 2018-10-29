import React from "react";
import Post from "./Post";
import api from "../api";

class PostsContainer extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            followMouseContent: "",
            mousePosition: {
                x: 0,
                y: 0
            }
        }
    }
    render() {
        if (this.props.normalized != null && this.props.raw != null) {
            let rawKeys = Object.keys(this.props.raw);
            return (
                <div className="posts-container"> 
                    <div className="posts-container-posts-count">
                        Posts found: {api.batchesController.count}
                    </div>
                    {
                        this.state.followMouseContent.length > 0 ?
                            <div 
                                style={{
                                    left: this.state.mousePosition.x,
                                    top: this.state.mousePosition.y + 10
                                }}
                                className="follow-mouse-content">{this.state.followMouseContent}
                            </div> : ""
                    }
                    {
                        rawKeys.map((key, i) => {
                            return <Post key={i} 
                                normalized={this.props.normalized[key]} 
                                raw={this.props.raw[key]}
                                updateFloatingContent={(mousePos, value) => this.updateFloatingContent(mousePos, value)}
                            />
                        })
                    }
                    {
                        !api.batchesController.isLastBatch() ? 
                            <div className="show-more-posts" onClick={(e) => this.props.loadMore()}><span>Show more</span></div> :
                            ""
                    }
                </div>
            )
        }
        return <div className="no-posts-found">No Posts Found</div>
    }

    updateFloatingContent = (mousePos, text) => {
        if (this.state.followMouseContent === text) return;
        if (typeof(text) !== "string") return;
        this.setState({
            mousePosition: mousePos, 
            followMouseContent: text
        })
    }
}

export default PostsContainer;