var DocumentVersionForm = React.createClass({
        getInitialState: function () {
            return {
                "uploader_id": this.props.user.id, // These probably don't need to be state as they never change.
                "uploader_account_type": this.props.user.account_type,
                "document_id": this.props.document.id,
                "s3_link": ''
            };
        },
        handleCallback: function (data) {
            this.props.handleNewDocumentVersion(data);
            this.setState(this.getInitialState);
        },
        handleFinished: function(signResult, file) {
            this.setState({'s3_link': signResult.uploadedFileName});
            var requestData = JSON.stringify(this.state);
            console.log("request data: ");
            console.log(requestData);
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
        render: function () {
            return (
                <div className="row">
                    <div className="col-md-2">
                      <div>Add new version</div>
                    </div>
                    <div className="col-md-2"><ReactS3Uploader
                        signingUrl="/s3/uploadUrl"
                        accept="*/*"
                        onProgress={this.onUploadProgress}
                        onError={this.onUploadError}
                        onFinish={this.handleFinished}
                        uploadRequestHeaders={{ 'x-amz-acl': 'public-read' }}
                        contentDisposition="inline"/>
                    </div>
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
