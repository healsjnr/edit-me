jest.dontMock('../User');

global.React       = require('react');
global.ReactDOM    = require('react-dom');
global.TestUtils   = require('react-addons-test-utils');

const User = require('../User');

describe('User', () => {
    it('should tell use the users name', () => {
        var userProps = {first_name: 'eigor', last_name: 'gonzalez'};

        var user = TestUtils.renderIntoDocument(
            <User user= {userProps} />
        );

        var userNode = ReactDOM.findDOMNode(user);
        expect(userNode.textContent).toEqual('Eigor Gonzalez');
    });
});
