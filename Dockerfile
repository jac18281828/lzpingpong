FROM ghcr.io/collectivexyz/foundry:latest

RUN python3 -m pip install slither-analyzer --break-system-packages

ARG PROJECT=lzpingpong
WORKDIR /workspaces/${PROJECT}
ENV USER=foundry
USER foundry
ENV PATH=${PATH}:~/.cargo/bin:/usr/local/go/bin

RUN chown -R foundry:foundry .

COPY --chown=foundry:foundry package.json .
COPY --chown=foundry:foundry package-lock.json .
COPY --chown=foundry:foundry node_modules node_modules

RUN npm ci --frozen-lockfile

COPY --chown=foundry:foundry . .

RUN yamlfmt -lint .github/*.yml .github/workflows/*.yml

RUN forge install
RUN forge fmt --check
# RUN python3 -m slither . --exclude-dependencies || true
RUN npm run lint
