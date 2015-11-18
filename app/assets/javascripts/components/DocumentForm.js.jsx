var DocumentForm = React.createClass({
        getInitialState: function() {
            return {
                "owner_id": this.props.user.id,
                "title":'',
                "original_file_name": '',
                "status": 'new'
            };
        },
        handleChange: function(e) {
            var name = e.target.name;
            var obj = {};
            obj[""+name] = e.target.value;
            this.setState(obj);
        },
        handleCallback: function(data) {
            console.log("props: " + JSON.stringify(this.props));
            this.props.handleNewDocument(data);
            this.setState(this.getInitialState);
        },
        handleSubmit: function(e) {
            var requestData = JSON.stringify(this.state)
            e.preventDefault();
            var xhr = $.ajax({
                url: '/documents',
                type: 'POST',
                data: requestData,
                contentType: 'application/json',
                accept: 'application/json',
                dataType: 'json',
                success: this.handleCallback
            });
        },
        valid: function() {
            return this.state.title && this.state.original_file_name;
        },
        render: function() {
            return (
                <form className="form-inline" onSubmit={this.handleSubmit}>
                    <div className="form-group">
                        <input type="text" className="form-control" placeholder="Title" name="title" value={this.state.title} onChange={this.handleChange}/>
                    </div>
                    <div className="form-group">
                        <input type="text" className="form-control" placeholder="Original File Name" name="original_file_name" value={this.state.original_file_name} onChange={this.handleChange}/>
                    </div>
                    <button type="submit" className="btn btn-primary" disabled={!this.valid}>
                        New Document
                    </button>
                </form>
            );
        }
    }
);

DocumentForm.propTypes = {
    user: React.PropTypes.object.isRequired,
    handleNewDocument: React.PropTypes.func.isRequired
};