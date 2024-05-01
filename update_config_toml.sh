#!/bin/bash

# Update the config.toml with the seed node and the peers for the MANTRA Hongbai Chain (Testnet).

CONFIG_TOML="$HOME/.mantrachain/config/config.toml"
SEEDS="d6016af7cb20cf1905bd61468f6a61decb3fd7c0@34.72.142.50:26656"
PEERS="da061f404690c5b6b19dd85d40fefde1fecf406c@34.68.19.19:26656,20db08acbcac9b7114839e63539da2802b848982@34.72.148.3:26656"

sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $CONFIG_TOML
sed -i.bak -e "s/^seeds =.*/seeds = \"$SEEDS\"/" $CONFIG_TOML
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $CONFIG_TOML
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0002uom"|g' $CONFIG_TOML
sed -i 's|^prometheus *=.*|prometheus = true|' $CONFIG_TOML
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $CONFIG_TOML