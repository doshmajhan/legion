const Controller = artifacts.require("Controller");

contract("Controller", async accounts => {
    it("should set command and retrieve", async () => { 
        const contract_account = accounts[1];
        const new_command = "doshmajhan";
        console.log(contract_account);
        let control = await Controller.deployed()
        await control.set_command.sendTransaction(new_command, {from: contract_account});
        let command  = await control.get_command.call();
        console.log(command);
        assert.equal(
            new_command,
            command,
            "Commands did not match, error with setting or getting"
        );
    });
})