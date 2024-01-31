SDK User Guide

### 1.design thought

​		The main purpose is to test the communication between L1 and L2 by operating the op bridge through the sdk. It is mainly divided into two types of transactions, deposit and withdraw, for testing and verification. We deploy a contract (greet) on L1 and L2, and we implement cross-chain data transfer through calls to both contracts.

- deposit（L1-->L2）direction

  Originally, the L2 contract greeting was ：“hello world.”

  L1 sends a greeting to L2，“Hello L2 ，I am L1.”

  Querying the L2 greeting becomes：“Hello L2 ，I am L1.”

- withdraw（L2-->L1) 方向

  Originally，the L1 contract greeting was ：“hello world.”

  L2 sends a greeting to L1，“Hello L1 ，I am L2.”

  Querying the L1 greeting becomes：“Hello L1 ，I am L2.”

### 2.experimentation

We assume that L1 and L2 are working properly.

#### 2.1.setting

Go to the sdk directory, edit the network.json file, and configure L1 and L2 basic information

```json
{
  "L1": {
     "url": "http://192.168.230.137:7545",
     "accounts": ["0x29ca9bc036a8f88c2aa3d57969b508189094f4814e01f4969c49250fecfe3e04"],
     "addrs": ["0xd5355603c407B6688fd0F995D8c4F98DD3a91aF5"],
     "chainId": 100
   },
   "L2": {
     "url": "http://192.168.230.131:8545",
     "accounts": ["0x29ca9bc036a8f88c2aa3d57969b508189094f4814e01f4969c49250fecfe3e04"],
     "addrs": ["0xd5355603c407B6688fd0F995D8c4F98DD3a91aF5"],
     "chainId": 118
   }
}
```

To facilitate testing, configure an account private key and address for L1 and L2.

#### 2.2.Transfer from L1 address to L2

```shell
sdk> yarn hardhat run test/01-transfer_L1.js --network L1
```

Before performing this step, ensure that there are sufficient ether in the L1 address configured in 2.1.

#### 2.3.Check whether the funds have arrived

On L2, check whether the configured address has received the transferred funds

```shell
sdk> yarn hardhat run test/02-balance_L2.js --network L2

BigNumber { value: "0" }
BigNumber { value: "0" }
BigNumber { value: "0" }
BigNumber { value: "10000000000000000000" }
transfer successful
Done in 156.52s.
```

#### 2.4.Deploy greet contract

```shell
sdk> yarn hardhat run test/03-deployer.js --network L1  #deploy to L1

Testing with greeter at 0xea563ce256583121652ee17E159Ec0A7d83e8cCc
JSON file update successful
Done in 10.54s.
```

```shell
sdk> yarn hardhat run test/03-deployer.js --network L2  #deploy to L2

Testing with greeter at 0x363c9413c03901aA327d250d819237DE6b0280dd
JSON file update successful
Done in 10.54s.
```

#### 2.5.Deposit transaction

##### 2.5.1.Query L2 original greeting

```shell
sdk> yarn hardhat run test/05-deposit_L2.js --network L2  

Hello, world!
Done in 10.53s.
```

##### 2.5.2.L1 sends a greeting to L2

```shell
sdk> yarn hardhat run test/04-deposit_L1.js --network L1  

More output, as long as no error can be reported
```

##### 2.5.3.Query greetings received by L2

Wait for a moment and query the greetings received by L2. If the greetings do not change, query them again later.

```she&#39;l&#39;l
sdk> yarn hardhat run test/05-deposit_L2.js --network L2  

Hello L2.I am L1.
Done in 10.53s.
```

At this point, deopost's operation is basically complete.

#### 2.6withdraw transaction

##### 2.6.1.L2 sends greetings to L1

```shell
sdk> yarn hardhat run test/06-withdraw_L2.js --network L2  

More output, as long as no error can be reported
```

##### 2.6.2.Confirmation on L1

```shell
sdk> yarn hardhat run test/07-withdraw_L1.js --network L1 

greet message ： Hello, world!	#The original greeting on L1
current message status is 2_STATE_ROOT_NOT_PUBLISHED	#The initial state 
current message status is 2_STATE_ROOT_NOT_PUBLISHED
current message status is 2_STATE_ROOT_NOT_PUBLISHED
current message status is 2_STATE_ROOT_NOT_PUBLISHED
current message status is 2_STATE_ROOT_NOT_PUBLISHED
current message status is 2_STATE_ROOT_NOT_PUBLISHED
current message status is 2_STATE_ROOT_NOT_PUBLISHED
current message status is 3_READY_TO_PROVE	#The transaction has been submitted to L1
proveMessage result [object Object]			#transaction confirmation operation
current message status is 4_IN_CHALLENGE_PERIOD			#challenge state
current message status is 4_IN_CHALLENGE_PERIOD
current message status is 4_IN_CHALLENGE_PERIOD
current message status is 4_IN_CHALLENGE_PERIOD
current message status is 4_IN_CHALLENGE_PERIOD
current message status is 5_READY_FOR_RELAY			#The transaction can be finalized
finalizeMessage result [object Object]				#transaction finallze operation
final greet message ： Hello L1， I am L2.		   #Greeting message received
Done in 172.44s.
```

As you can see from the output above, an withdraw transaction will be in the following 4 states in L1. You need to experiment with the sdk twice to finally complete the transaction confirmation operation.

```shell
STATE_ROOT_NOT_PUBLISHED (2): The state root has not been published yet. You need to wait until it is published.
READY_TO_PROVE (3): Ready for the next step
IN_CHALLENGE_PERIOD (4): Still in the challenge period, wait a few seconds.
READY_FOR_RELAY (5): Ready to finalize the message. Go on to the next step.
```

refer：[optimism-tutorial/cross-dom-comm at main · ethereum-optimism/optimism-tutorial (github.com)](https://github.com/ethereum-optimism/optimism-tutorial/tree/main/cross-dom-comm)