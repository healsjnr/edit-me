require('../utils.js');
import Documents from "./Documents.jsx";

export default class User extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className='user'>
        <h1>{this.props.user.first_name.capitalizeFirstLetter()} {this.props.user.last_name.capitalizeFirstLetter()}</h1>
        <hr/>
        <Documents user={this.props.user}/>
      </div>
    );
  }
}
