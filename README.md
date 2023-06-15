# Running a node (Lighthouse/Geth) on EIP-4844 devnet-5

Docker Compose setup for running a Lighthouse/Geth node on devnet v5. Builds docker images from `eip4844` branches of Lighthouse and Geth.

## Run with Docker

```
docker-compose up
```

To rebuild images from latest geth & lighthouse devnet-6 repos:

```
docker-compose build --no-cache
```

## How to test

https://hackmd.io/@jimmygchen/H1XUtBIfn

## References 

- [4844-devnet-6](https://4844-devnet-6.ethpandaops.io/)
