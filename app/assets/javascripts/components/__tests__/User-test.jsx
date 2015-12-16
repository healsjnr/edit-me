jest.dontMock('../User');

React       = require('react/addons');
TestUtils   = React.addons.TestUtils;

describe('User', function() {
    it('should tell use the users name', function() {
        var User = require('../User');
        var userProps = {first_name: 'eigor', last_name: 'gonzalez'};

        var user = TestUtils.renderIntoDocument(
            <User user= {userProps} />
        );

        var userNode = user.getDOMNode();
        expect(userNode.textContent).toEqual('Eigor Gonzalez');
    });
});