var renderDate = require('utils');
var DocumentVersion = React.createClass({
    renderName: function(uploader) {
        return uploader.first_name.capitalizeFirstLetter() + " " + uploader.last_name.capitalizeFirstLetter();
    },
    render: function() {
        return (
            <div className="container-fluid">
                <div className="row">
                    <div className="col-md-1"> {this.props.documentVersion.version} </div>
                    <div className="col-md-2"> {this.props.documentVersion.s3_link} </div>
                    <div className="col-md-2"> {this.renderName(this.props.documentVersion.uploader)} </div>
                    <div className="col-md-2"> {this.props.documentVersion.uploader_account_type} </div>
                    <div className="col-md-2"> {renderDate(this.props.documentVersion.created_at)} </div>
                    <div className="col-md-2"> {renderDate(this.props.documentVersion.updated_at)} </div>
                </div>
            </div>
        );
    }
});

DocumentVersion.propTypes = {
    documentVersion: React.PropTypes.object.isRequired
};
module.exports = DocumentVersion;
