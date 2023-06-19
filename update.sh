#!/bin/sh

INVENTORY_URI=https://config.4844-devnet-6.ethpandaops.io/api/v1/nodes/inventory

# EL
GENESIS_URI=https://config.4844-devnet-6.ethpandaops.io/el/chainspec.json
TRUSTED_SETUP_URI=https://config.4844-devnet-6.ethpandaops.io/trusted_setup.txt

# CL
DEPOSIT_CONTRACT_URI=https://config.4844-devnet-6.ethpandaops.io/deposit_contract.txt
DEPOSIT_CONTRACT_BLOCK_URI=https://config.4844-devnet-6.ethpandaops.io/cl/deposit_contract_block.txt
DEPLOY_BLOCK_URI=https://config.4844-devnet-6.ethpandaops.io/cl/deploy_block.txt
GENESIS_CONFIG_URI=https://config.4844-devnet-6.ethpandaops.io/cl/config.yaml
GENESIS_SSZ_URI=https://config.4844-devnet-6.ethpandaops.io/cl/genesis.ssz

# nethermind
cd nethermind
wget -O genesis.json $GENESIS_URI;
curl -s $INVENTORY_URI | jq -r '.ethereum_pairs[] | .execution.enode' > bootnodes.txt;
curl -s $INVENTORY_URI | jq -r '.ethereum_pairs[] | .execution.enode' | tr '\n' ',' > bootnodes2.txt;
wget -O trusted_setup.txt $TRUSTED_SETUP_URI;
cat genesis.json | jq -r '.config.chainId' > chainid.txt;
openssl rand -base64 48 > jwtsecret

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
