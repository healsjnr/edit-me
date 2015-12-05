var TestUpload = React.createClass({
    render: function () {
        return (
            <ReactS3Uploader
                signingUrl="/s3/uploadUrl"
                accept="*/*"
                onProgress={this.onUploadProgress}
                onError={this.onUploadError}
                onFinish={this.onUploadFinish}
                uploadRequestHeaders={{ 'x-amz-acl': 'public-read' }}
                contentDisposition="inline" />

        );
    }
});

module.exports = TestUpload;
