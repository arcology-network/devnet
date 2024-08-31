# Testing L1-L2 Interactions

This guide explores testing the interaction between L1 and L2 networks using the OP bridge, focusing on "deposit" and "withdraw" transactions. In addition, This documentation details deploying a "greet" contract on both L1 and L2 and outlines the process for cross-chain data transfer through these greetings. Here's how it works:

Deposit (L1 to L2):

- Initial L2 greeting: "hello world."
- L1 sends a message: "Hello L2, I am L1."
- Updated L2 greeting: "Hello L2, I am L1."
- Withdraw (L2 to L1):

Initial L1 greeting: "hello world."
- L2 sends a message: "Hello L1, I am L2."
- Updated L1 greeting: "Hello L1, I am L2."


## 1. Prerequisites

- A Live L1 and L2 network
- Node.js
- Yarn
- Hardhat

>>:warning: All the steps blow are executed on **the machine where the Arcology Node is running**. So if you are using the docker deployment, you must log in to the container where L2 is running first:
>>
>>```shell
>>    devnet> sudo docker exec -it l2 /bin/bash
>>```
>> Replace `l2` with your container name if needed.


### 3.1 Deposit from L1 to L2

First, we are going to transfer some funds from L1 to L2 to ensure that the L2 address has sufficient balance to deploy the greet contract. Before this step, ensure that the sender has sufficient balance.

```shellls
devnet> cd op/sdk
devnet/op/sdk> sudo yarn hardhat run test/01-transfer_L1.js --network L1
```

### 3.2. Check the Balance on L2

On the machine where L2 is running, check if the recipient address has successfully received the transferred funds.

```shell
devnet/op/sdk> yarn hardhat run test/02-balance_L2.js --network L2
```

If the balance is successfully updated, you will see the following output:

```shell
BigNumber { value: "0" }
BigNumber { value: "0" }
BigNumber { value: "0" }
BigNumber { value: "10000000000000000000" }
transfer successful
Done in 156.52s.
```
>> :warning: **The balance won't be updated immediately. Depending on the comfirmation time, it may take a few minutes to update.**


### 2.4. Deploy the Greet Contract

```shell
devnet/op/sdk> yarn hardhat run test/03-deployer.js --network L1  #deploy to L1
```
If the deployment is successful, you will see the following output:

```
Testing with greeter at 0xea563ce256583121652ee17E159Ec0A7d83e8cCc
JSON file update successful
Done in 10.54s.
```

```shell
devnet/op/sdk> yarn hardhat run test/03-deployer.js --network L2  #deploy to L2
```
Yill see the following output if the deployment is successful:

```
Testing with greeter at 0x363c9413c03901aA327d250d819237DE6b0280dd
JSON file update successful
Done in 10.54s.
```

## 2.5.Deposit transaction

### 2.5.1.Query L2 original greeting

```shell
devnet/op/sdk> yarn hardhat run test/05-deposit_L2.js --network L2  

Hello, world!
Done in 10.53s.
```

### 2.5.2.L1 sends a greeting to L2

```shell
devnet/op/sdk> yarn hardhat run test/04-deposit_L1.js --network L1  

More output, as long as there is no error
```

### 2.5.3.Query greetings received by L2

Wait for a moment and query the greetings received by L2. If the greetings do not change, query them again later.

```shell
devnet/op/sdk> yarn hardhat run test/05-deposit_L2.js --network L2  

Hello L2.I am L1.
Done in 10.53s.
```

At this point, deopost's operation is basically complete.

## 2.6 Withdraw

### 2.6.1. L2 Sends Greetings to L1

```shell
devnet/op/sdk> yarn hardhat run test/06-withdraw_L2.js --network L2  

More output, as long as no error can be reported
```

### 2.6.2.Confirmation on L1

```shell
devnet/op/sdk> yarn hardhat run test/07-withdraw_L1.js --network L1 

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