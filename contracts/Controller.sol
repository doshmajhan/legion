pragma solidity >=0.4.21 <0.6.0;

contract Controller {
    string public message;
    
    function send_command() public {
        message = "echo 'hello'";
    }
}