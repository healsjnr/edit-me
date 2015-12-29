jest.dontMock('../User');

React       = require('react');
ReactDOM    = require('react-dom');
TestUtils   = require('react-addons-test-utils');

describe('User', function() {
    it('should tell use the users name', function() {
        var User = require('../User');
        var userProps = {first_name: 'eigor', last_name: 'gonzalez'};

        var user = TestUtils.renderIntoDocument(
            <User user= {userProps} />
        );

        var userNode = ReactDOM.findDOMNode(user);
        expect(userNode.textContent).toEqual('Eigor Gonzalez');
    });
});