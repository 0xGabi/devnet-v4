#!/bin/sh
set -ue

DEPOSIT_CONTRACT_URI=https://config.4844-devnet-4.ethpandaops.io/deposit_contract.txt;
DEPOSIT_CONTRACT_BLOCK_URI=https://config.4844-devnet-4.ethpandaops.io/cl/deposit_contract_block.txt;
DEPLOY_BLOCK_URI=https://config.4844-devnet-4.ethpandaops.io/cl/deploy_block.txt;
GENESIS_CONFIG_URI=https://config.4844-devnet-4.ethpandaops.io/cl/config.yaml;
GENESIS_SSZ_URI=https://config.4844-devnet-4.ethpandaops.io/cl/genesis.ssz;
BOOTNODE_URI=https://config.4844-devnet-4.ethpandaops.io/bootstrap_nodes.txt;

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
	--bootstrap-node="enr:-Iq4QAw-ZQb0IiosZgDDcK5ehLs1XmwT0BWU1E1W3ZnhlAAwAE3I46dgCsCbeB5QUwcpDmpFfveTfKF7-tiIg0KWGjqGAYXoIfe6gmlkgnY0gmlwhKEjXcqJc2VjcDI1NmsxoQN4HpB2GMFY2MzwO9hGFjqRG47OX4hGDliAG-mJNWkEr4N1ZHCCIyk" \
	--genesis-state=/data/testnet_spec/genesis.ssz \
	--chain-config-file=/data/testnet_spec/config.yaml \
	--execution-endpoint=http://geth:8551
