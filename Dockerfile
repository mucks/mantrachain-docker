FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"] 

# ref: https://docs.mantrachain.io/operate-a-node/set-up-a-node

# Update system & install prerequisites.
RUN apt update
RUN apt upgrade -y
RUN apt install -y curl git jq lz4 build-essential unzip sudo
RUN bash <(curl -s "https://raw.githubusercontent.com/MANTRA-Finance/public/main/go_install.sh")
RUN source ~/.bash_profile

WORKDIR /root

# Install binary.
RUN mkdir bin
RUN cd bin
RUN source ~/.profile
RUN apt install -y wget
RUN wget https://github.com/MANTRA-Finance/public/raw/main/mantrachain-hongbai/mantrachaind-linux-amd64.zip
RUN unzip mantrachaind-linux-amd64.zip

# Install cosmwasm library
RUN wget -P /usr/lib https://github.com/CosmWasm/wasmvm/releases/download/v1.3.1/libwasmvm.x86_64.so

# Initialise node
RUN ./mantrachaind init bitvortex --chain-id mantra-hongbai-1

# Download genesis file
RUN curl -Ls https://github.com/MANTRA-Finance/public/raw/main/mantrachain-hongbai/genesis.json > $HOME/.mantrachain/config/genesis.json
# Update the config.toml with the seed node and the peers for the MANTRA Hongbai Chain (Testnet).
COPY update_config_toml.sh .
RUN chmod +x update_config_toml.sh
RUN ./update_config_toml.sh


# Install Cosmovisor
RUN /usr/local/go/bin/go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
RUN mkdir -p ~/.mantrachain/cosmovisor/genesis/bin
RUN mkdir -p ~/.mantrachain/cosmovisor/upgrades
RUN cp ~/mantrachaind ~/.mantrachain/cosmovisor/genesis/bin

ENV DAEMON_NAME=mantrachaind
ENV DAEMON_HOME=/root/.mantrachain
ENV DAEMON_ALLOW_DOWNLOAD_BINARIES=false
ENV DAEMON_RESTART_AFTER_UPGRADE=true
ENV UNSAFE_SKIP_BACKUP=true

# Start the node
CMD ["./go/bin/cosmovisor", "run", "start"]




