#!/bin/sh
set -e

BASE_URL=https://config.4844-devnet-7.ethpandaops.io
INVENTORY_URI=$BASE_URL/api/v1/nodes/inventory

# EL
GENESIS_URI=$BASE_URL/el/chainspec.json
TRUSTED_SETUP_URI=$BASE_URL/trusted_setup.txt

# CL
DEPOSIT_CONTRACT_URI=$BASE_URL/deposit_contract.txt
DEPOSIT_CONTRACT_BLOCK_URI=$BASE_URL/cl/deposit_contract_block.txt
DEPLOY_BLOCK_URI=$BASE_URL/cl/deploy_block.txt
GENESIS_CONFIG_URI=$BASE_URL/cl/config.yaml
GENESIS_SSZ_URI=$BASE_URL/cl/genesis.ssz

# nethermind
cd nethermind
wget -O genesis.json $GENESIS_URI;
curl -s $INVENTORY_URI | jq -r '.ethereum_pairs[] | .execution.enode' > bootnodes.txt;
curl -s $INVENTORY_URI | jq -r '.ethereum_pairs[] | .execution.enode' | tr '\n' ',' > bootnodes2.txt;
wget -O trusted_setup.txt $TRUSTED_SETUP_URI;
cat genesis.json | jq -r '.config.chainId' > chainid.txt;
openssl rand -hex 32 > jwtsecret

cd ..

# lodestar
cd lodestar

mkdir -p testnet_spec
curl -s $INVENTORY_URI | jq -r '.ethereum_pairs[] | .consensus.enr' > bootnodes.txt;
wget -O testnet_spec/deposit_contract.txt $DEPOSIT_CONTRACT_URI
wget -O testnet_spec/deposit_contract_block.txt $DEPOSIT_CONTRACT_BLOCK_URI
wget -O testnet_spec/deploy_block.txt $DEPLOY_BLOCK_URI
wget -O testnet_spec/config.yaml $GENESIS_CONFIG_URI
wget -O testnet_spec/genesis.ssz $GENESIS_SSZ_URI
wget -O testnet_spec/trusted_setup.txt $TRUSTED_SETUP_URI
(tr '\n' ',' < bootnodes.txt | sed 's/[^,]*/"&"/g') > bootnodes2.txt;
mv bootnodes2.txt bootnodes.txt;

cd ..
