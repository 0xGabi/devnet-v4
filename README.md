# Running a node (Nethermind/lodestar) on EIP-4844 devnet-6

Working intermitently until some bugs are fixed in clients for devnet-6.

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

