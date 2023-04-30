#!/bin/sh
set -ue

BOOTNODE_URI=https://config.4844-devnet-5.ethpandaops.io/el/bootnodes
GENESIS_URI=https://config.4844-devnet-5.ethpandaops.io/el/genesis.json

if ! [ -f /data/genesis_init_done ];
then
  wget -O /data/genesis.json $GENESIS_URI;
  wget -O /data/bootnodes.txt $BOOTNODE_URI;
  apk update && apk add jq;
  cat /data/genesis.json | jq -r '.config.chainId' > /data/chainid.txt;
  geth init --datadir /data /data/genesis.json;
  touch /data/genesis_init_done;
  echo "genesis init done";
else
  echo "genesis is already initialized";
fi;
echo "bootnode init done: $(cat /data/bootnodes.txt)";

exec geth \
	--datadir /data \
	--bootnodes="$(tr '\n' ',' < /data/bootnodes.txt)" \
	--networkid="$(cat /data/chainid.txt)" \
	--ws \
	--ws.addr=0.0.0.0 \
	--ws.api="eth,net,engine,web3,txpool" \
	--http \
	--http.addr=0.0.0.0 \
	--http.api="eth,net,engine,web3,txpool" \
	--syncmode=full \
	--authrpc.jwtsecret /config/jwtsecret \
	--authrpc.vhosts="*" \
	--authrpc.addr=0.0.0.0 \
	--verbosity 3
