pragma solidity^0.5.0;

contract Controller {
    address owner;
    string public command;
    
    constructor() public {
        owner = msg.sender;
    }

    function send_command() public returns (string memory) {
        command = "echo 'hello'";
        return command;
    }
}