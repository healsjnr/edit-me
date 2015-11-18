var Documents = React.createClass({
    getInitialState: function () {
        // Todo: They recomend storing minimal state, so maybe I should transpose this into a view object.
        return {documents: this.props.documents};
    },
    getDefaultProps: function () {
        return {documents: []};
    },
    addDocument: function(document) {
        var docs = this.state.documents.slice();
        docs.push(document);
        this.setState({documents: docs})

    },
    componentDidMount: function () {
        var request_url = '/documents';
        $.ajax({
            url: request_url,
            dataType: 'json',
            cache: false,
            success: function (data) {
                console.log("data received")
                console.log(data)
                this.setState({documents: data});
            }.bind(this),
            error: function (xhr, status, err) {
                console.error(request_url, status, err.toString());
            }.bind(this)
        })
    },
    render: function () {
        var user = this.props.user;
        var documents = this.state.documents.map(function(doc, index) {
            return <Document key={doc.id} document={doc} user={user}/>;
        });
        return (
            <div className="documents container-fluid">
                <div className="row">
                    <h2 className='title'>
                        Documents
                    </h2>
                </div>
                <div className="row">
                    <DocumentForm handleNewDocument={this.addDocument} user={this.props.user}/>
                    {documents}
                </div>
            </div>
        );
    }
});

Documents.propTypes = {
    user: React.PropTypes.object.isRequired
};
