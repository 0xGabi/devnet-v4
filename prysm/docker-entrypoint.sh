#!/bin/sh
set -ue

DEPOSIT_CONTRACT_URI=https://config.4844-devnet-6.ethpandaops.io/deposit_contract.txt;
DEPOSIT_CONTRACT_BLOCK_URI=https://config.4844-devnet-6.ethpandaops.io/cl/deposit_contract_block.txt;
DEPLOY_BLOCK_URI=https://config.4844-devnet-6.ethpandaops.io/cl/deploy_block.txt;
GENESIS_CONFIG_URI=https://config.4844-devnet-6.ethpandaops.io/cl/config.yaml;
GENESIS_SSZ_URI=https://config.4844-devnet-6.ethpandaops.io/cl/genesis.ssz;
BOOTNODE_URI=https://config.4844-devnet-6.ethpandaops.io/bootstrap_nodes.txt;
TRUSTED_SETUP_URI=https://config.4844-devnet-6.ethpandaops.io/trusted_setup.txt;

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
  wget -O /data/testnet_spec/trusted_setup.txt $TRUSTED_SETUP_URI;
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
    --bootstrap-node="enr:-Ly4QLTwOhNRfN_nSMkeDl8F-y6tpNW3lBlMqrQ49t2YwOukHXKRBkChzEJ_ixPdjCud4IDqJkeKAZbGvUE5qbgv7bwDh2F0dG5ldHOIDAAAAAAAAACEZXRoMpDEP0jPUEhEBv__________gmlkgnY0gmlwhEDjRp-Jc2VjcDI1NmsxoQPNjqoPfJLpv6lKkZp7W9kMp81PnTuBmjGCOCMYOrwhh4hzeW5jbmV0cwCDdGNwgiMog3VkcIIjKA,enr:-KG4QEavHsltQ6ttCLfszK6r1BLSYpQXPMM7dpsJrNMDgk3AW5AlStBjAgo6DU9QV5AWjLJLF4OZsatMYOkCKRZ-5VsDhGV0aDKQxD9Iz1BIRAb__________4JpZIJ2NIJpcISkWs49iXNlY3AyNTZrMaEDpC8M8vyCimVtGMJp8TO-uKF0faIqdo7nnDBlAIH9o3aDdGNwgiMog3VkcIIjKA,enr:-KG4QIhN23q4M1xpcEZK9wo3glFZdTXvfIXD2rh4Jf1_ZkkCEXT9t5nrZ0lQhXYmwdrfxAKqo2TLRNqIfJFHs0Ic6tE1hGV0aDKQxD9Iz1BIRAb__________4JpZIJ2NIJpcIRA4UdSiXNlY3AyNTZrMaEDUjdh3y9NHawzOG8B-f51nIAnnnpaz2D_ykjTt1aAHvWDdGNwgiMog3VkcIIjKA,enr:-MS4QMz-WasekmD0D--VCAEQgSQWBdtzbdB1BtNO30R-d8jnPvGEVQdw_tGokJDUgtuhDDxGH-VCBG_bEr2mlehD9tMHh2F0dG5ldHOIAAAAAAAAAACEZXRoMpDEP0jPUEhEBv__________gmlkgnY0gmlwhEDhR5WJc2VjcDI1NmsxoQMVmzh7knmX81SYb-ozUQGyczuyTUpjRSsgMpeuQbk2NIhzeW5jbmV0c4gAAAAAAAAAAIN0Y3CCIyiDdWRwgiMo,enr:-KG4QBnPJVMgzwSpzyRXXIA1ET3OtEImV3mgsriXTvbH0KcUMV1x12Jd7KuUXbCesCds4mPiq_dQcENtfp512OWqsGglhGV0aDKQxD9Iz1BIRAb__________4JpZIJ2NIJpcIRA4UeUiXNlY3AyNTZrMaEDh6uoOe6wzCjVl1iB99DAVNhB_vZlQLJ0BXafqlyt1PaDdGNwgiMog3VkcIIjKA"
    --genesis-state=/data/testnet_spec/genesis.ssz \
    --chain-config-file=/data/testnet_spec/config.yaml \
    --contract-deployment-block=0 \
    --execution-endpoint=http://geth:8551 \
    --min-sync-peers=1
