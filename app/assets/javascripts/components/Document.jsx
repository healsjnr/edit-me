var DocumentVersion = require('./DocumentVersion.jsx');
var DocumentVersionForm = require('./DocumentVersionForm.jsx');
var renderDate = require('../utils');
var Document = React.createClass({
    getInitialState: function () {
        return {documentVersions: this.props.document.document_version};
    },
    addDocumentVersion: function (document) {
        var docVersions = this.state.documentVersions.slice();
        docVersions.push(document);
        this.setState({documentVersions: docVersions})
    },
    buildDocumentVersion: function () {
        var documentVersions = this.state.documentVersions.map(function (docVersion, index) {
            return <DocumentVersion key={docVersion.id} documentVersion={docVersion}/>;
        });
        if (documentVersions.length == 0) {
            return "No files uploaded yet"
        } else {
            return documentVersions;
        }
    },
    render: function () {
        //TODO styling on these to align properly
        return (
            <div className="container-fluid">
                <div className="row">
                    <div className="col-md-3"> <h3>{this.props.document.title} </h3></div>
                    <div className="col-md-2"> <h3>{this.props.document.status} </h3></div>
                    <div className="col-md-2"> <h3>{this.props.document.source} </h3></div>
                    <div className="col-md-2"> <h4>{renderDate(this.props.document.created_at)} </h4></div>
                    <div className="col-md-2"> <h4>{renderDate(this.props.document.updated_at)} </h4></div>
                </div>
                <div className="row">{this.buildDocumentVersion()}</div>
                <div className="row">
                    <hr/>
                    <DocumentVersionForm handleNewDocumentVersion={this.addDocumentVersion}
                                         document={this.props.document}
                                         user={this.props.user} />
                </div>
                <hr/>
            </div>
        );
    }
});

Document.propTypes = {
    user: React.PropTypes.object.isRequired,
    document: React.PropTypes.object.isRequired
};
module.exports = Document;
