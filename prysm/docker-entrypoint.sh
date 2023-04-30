#!/bin/sh
set -ue

DEPOSIT_CONTRACT_URI=https://config.4844-devnet-5.ethpandaops.io/deposit_contract.txt;
DEPOSIT_CONTRACT_BLOCK_URI=https://config.4844-devnet-5.ethpandaops.io/cl/deposit_contract_block.txt;
DEPLOY_BLOCK_URI=https://config.4844-devnet-5.ethpandaops.io/cl/deploy_block.txt;
GENESIS_CONFIG_URI=https://config.4844-devnet-5.ethpandaops.io/cl/config.yaml;
GENESIS_SSZ_URI=https://config.4844-devnet-5.ethpandaops.io/cl/genesis.ssz;
BOOTNODE_URI=https://config.4844-devnet-5.ethpandaops.io/bootstrap_nodes.txt;

mkdir -p /data/testnet_spec;
if ! [ -f /data/testnet_spec/genesis.ssz ];
then
  apt-get -y update && apt-get -y install wget
  wget -O /data/testnet_spec/deposit_contract.txt $DEPOSIT_CONTRACT_URI;
  wget -O /data/testnet_spec/deposit_contract_block.txt $DEPOSIT_CONTRACT_BLOCK_URI;
  wget -O /data/testnet_spec/deploy_block.txt $DEPLOY_BLOCK_URI;
  wget -O /data/testnet_spec/config.yaml $GENESIS_CONFIG_URI;
  wget -O /data/testnet_spec/genesis.ssz $GENESIS_SSZ_URI;
  wget -O /data/testnet_spec/bootstrap_nodes.txt $BOOTNODE_URI;
  echo "genesis init done";
else
  echo "genesis exists. skipping...";
fi;
echo "bootnode init done: $(cat /data/testnet_spec/bootstrap_nodes.txt)";

# --p2p-host-ip=$(POD_IP)
exec /app/cmd/beacon-chain/beacon-chain \
    --accept-terms-of-use=true \
    --datadir=/data \
    --p2p-tcp-port=13000 \
    --p2p-udp-port=13000 \
    --rpc-host=0.0.0.0 \
    --rpc-port=4000 \
    --jwt-secret=/config/jwtsecret \
    --grpc-gateway-host=0.0.0.0 \
    --grpc-gateway-port=3500 \
    --monitoring-host=0.0.0.0 \
    --monitoring-port=8080 \
    --bootstrap-node="enr:-MS4QBEfqmQ7zLz7EuRC8xvAgbvuy5Cn0VrBVU27U6Rtq5nzPg1W2gyahsvCSie68A1gCyLamhK1BhOpxw8oDfiTNiEJh2F0dG5ldHOIAAAAAAAAAACEZXRoMpA9CJoRUEhEBf__________gmlkgnY0gmlwhIbRx2aJc2VjcDI1NmsxoQJoQoV-vbiuItOSCsczcQ9vvL_IoaNaslVeqUpnyxP0jYhzeW5jbmV0c4gAAAAAAAAAAIN0Y3CCIyiDdWRwgiMo" \
    --genesis-state=/data/testnet_spec/genesis.ssz \
    --chain-config-file=/data/testnet_spec/config.yaml \
    --contract-deployment-block=0 \
    --execution-endpoint=http://geth:8551 \
    --min-sync-peers=1
