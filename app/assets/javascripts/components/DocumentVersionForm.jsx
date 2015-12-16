var DocumentVersionForm = React.createClass({
        getInitialState: function () {
            return {
                "uploader_id": this.props.user.id, // These probably don't need to be state as they never change.
                "uploader_account_type": this.props.user.account_type,
                "document_id": this.props.document.id,
                "s3_link": ''
            };
        },
        handleChange: function (e) {
            var name = e.target.name;
            var obj = {};
            obj["" + name] = e.target.value;
            this.setState(obj);
        },
        handleCallback: function (data) {
            this.props.handleNewDocumentVersion(data);
            this.setState(this.getInitialState);
        },
        handleSubmit: function (e) {
            var requestData = JSON.stringify(this.state)
            e.preventDefault();
            var xhr = $.ajax({
                url: '/document_versions',
                type: 'POST',
                data: requestData,
                contentType: 'application/json',
                accept: 'application/json',
                dataType: 'json',
                success: this.handleCallback
            })
        },
        createDocument: function(requestData) {
            $.ajax({
                url: '/document_versions',
                type: 'POST',
                data: requestData,
                contentType: 'application/json',
                accept: 'application/json',
                dataType: 'json',
                success: this.handleCallback
            })
        },
        handleFinished: function(signResult, file) {
            console.log("Finished called.");
            console.log("File: " + file.name);
            console.log(signResult);
        },
        valid: function () {
            return this.state.s3_link;
        },
        render: function () {
            return (
                <div>
                    <form className="form-inline" onSubmit={this.handleSubmit}>
                        <div className="form-group">
                            <input type="text" className="form-control" placeholder="S3 Linke" name="s3_link"
                                   value={this.state.s3_link} onChange={this.handleChange}/>
                        </div>
                        <button type="submit" className="btn btn-primary" disabled={!this.valid}>
                            New Document
                        </button>
                    </form>
                    <ReactS3Uploader
                        signingUrl="/s3/uploadUrl"
                        accept="*/*"
                        onProgress={this.onUploadProgress}
                        onError={this.onUploadError}
                        onFinish={this.handleFinished}
                        uploadRequestHeaders={{ 'x-amz-acl': 'public-read' }}
                        contentDisposition="inline" />
                </div>
            );
        }
    }
);

DocumentVersionForm.propTypes = {
    user: React.PropTypes.object.isRequired,
    document: React.PropTypes.object.isRequired,
    handleNewDocumentVersion: React.PropTypes.func.isRequired
};
module.exports = DocumentVersionForm;
