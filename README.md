#  Run Ethereum devnet-7 with EIP-4844 for testing

Client pair:

* Execution client: Nethermind
* Consensus client: Lodestar

Working intermittently until some bugs are fixed in clients for devnet-6.

## Run

Update bootnodes and spec:

```
./update.sh
```

Configure your settings

```
cp .env.example .env
# adjust .env accordingly
```

Spin up docker containers:

```
docker-compose up -d
```


# References

* [devnet-6](https://4844-devnet-6.ethpandaops.io/) by @ethpandaops
* [eip4844-devnet repo](https://github.com/jimmygchen/eip4844-devnet) by @jimmygchen
* [EIP-4844 Devnet v6 Testing](https://hackmd.io/@jimmygchen/H1XUtBIfn) by @jimmygchen
