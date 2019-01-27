pragma solidity >=0.4.0 <0.6.0;

contract Controller {
    address owner;
    string public command;
    
    constructor() public {
        owner = msg.sender;
    }

    function set_command(string memory new_command) public {
        require(msg.sender == owner, "Must be owner");
        command = new_command;
    }
    
    function get_command() public view returns (string memory) {
        return command;
    }
}