import tonos_ts4.ts4 as ts4
from tonos_ts4.util import blue, cyan, green, red, yellow

eq = ts4.eq

ts4.init("../build/", verbose=False)
ts4.register_abi('Box')

Registry = ts4.BaseContract("Registry", {})
Hashing = ts4.BaseContract("Hashing", {})

Wallet = ts4.BaseContract("Wallet", {})
Wallet1 = ts4.BaseContract("Wallet", {})

Registry.call_method(
    "init", 
    {
        "codeBox": ts4.load_code_cell("Box")
    }
)

secretHash = Hashing.call_method("secretToHash", {"secret": "secret"})

print(yellow("Deploying box 1."))
Wallet.call_method(
                    "sendTransaction",
                {
                    "dest": Registry.address,
                    "value": 30000000000,
                    "bounce": False,
                    "flags": 3,
                    "payload":ts4.encode_message_body(
                        "Registry", "deployBox", {"recipient": Wallet1.address, 
                                                "amount": 1,
                                                "secretHash": secretHash,
                                                "timelock": 60})
                }
                )

ts4.dump_queue()
ts4.dispatch_messages()

deployedBoxesCounter = Registry.call_getter("_deployedBoxesCounter")
print (green("Deployed boxes: {}".format(deployedBoxesCounter)))

addressBox1 = Registry.call_getter(
        "resolveBox", {
            "addrAuthor": Registry.address,
            "id": deployedBoxesCounter - 1
        })

Box1 = ts4.BaseContract("Box", ctor_params=None, address=addressBox1)

print (yellow("Box 1 successfully deployed. Balance: {}".format(Box1.balance)))

print(yellow("\nDeploying box 2."))
Wallet1.call_method(
                    "sendTransaction",
                {
                    "dest": Registry.address,
                    "value": 50000000000,
                    "bounce": False,
                    "flags": 3,
                    "payload":ts4.encode_message_body(
                        "Registry", "deployBox", {"recipient": Wallet.address, 
                                                "amount": 4,
                                                "secretHash": secretHash,
                                                "timelock": 30})
                }
                )
ts4.dispatch_messages()

deployedBoxesCounter = Registry.call_getter("_deployedBoxesCounter")
print (green("Deployed boxes: {}".format(deployedBoxesCounter)))

addressBox2 = Registry.call_getter(
        "resolveBox", {
            "addrAuthor": Registry.address,
            "id": deployedBoxesCounter - 1
        })

Box2 = ts4.BaseContract("Box", ctor_params=None, address=addressBox2)

print (yellow("Box 2 successfully deployed. Balance: {}".format(Box2.balance)))

Box1Recipient = Box1.call_getter("_recipient")
Box2Recipient = Box2.call_getter("_recipient")

# print(red("Box1Recipient: {}".format(Box1Recipient)))
# print(red("Box2Recipient: {}".format(Box2Recipient)))
# print(red("Wallet addr: {}".format(Wallet.address)))
# print(red("Wallet1 addr: {}".format(Wallet1.address)))
print(yellow("\nCreator of box1 takes money from box2"))
print(green("Creator of box 1 balance before: {}".format(Wallet.balance)))
Box2.call_method("toRecipient", {"maybeSecret":"secret"})
ts4.dump_queue()
ts4.dispatch_messages()
print(green("Creator of box 1 balance after: {}".format(Wallet.balance)))

print(yellow("\nCreator of box2 takes money from box1"))
getSecret = Box2.call_getter("getSecret")
print (green("Get secret from box2: {}".format(getSecret)))
print(green("Creator of box 2 balance before: {}".format(Wallet1.balance)))
Box1.call_method("toRecipient", {"maybeSecret":getSecret})
ts4.dispatch_messages()
print(green("Creator of box 2 balance after: {}".format(Wallet1.balance)))