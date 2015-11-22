var Documents = require('./Documents');
var User = React.createClass({
        render: function() {
            return (
                  <div className='user'>
                      <h1>{this.props.user.first_name.capitalizeFirstLetter()} {this.props.user.last_name.capitalizeFirstLetter()}</h1>
                      <hr/>
                      <Documents user={this.props.user}/>
                  </div>
            );
        }
    }
);

User.propTypes = {
    user: React.PropTypes.object.isRequired
};

module.exports = User;
