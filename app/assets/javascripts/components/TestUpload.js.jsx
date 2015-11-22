var TestUpload = React.createClass({
    render: function () {
        return (
            <ReactS3Uploader
                signingUrl="/s3/sign"
                accept="image/*"
                onProgress={this.onUploadProgress}
                onError={this.onUploadError}
                onFinish={this.onUploadFinish}
                uploadRequestHeaders={{ 'x-amz-acl': 'public-read' }}
                contentDisposition="auto"
                server="http://cross-origin-server.com"/>

        );
    }
});

module.exports = TestUpload;
