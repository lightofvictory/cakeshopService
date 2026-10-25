FROM node:22-bookworm-slim AS build

USER root
WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 make g++ \
    && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build \
    && npm prune --omit=dev

FROM node:22-bookworm-slim AS runtime

USER root
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8080

COPY --from=build --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/dist ./dist
COPY --from=build --chown=node:node /app/package.json ./package.json

RUN mkdir -p /app/uploads \
    && chown node:node /app/uploads

USER node

EXPOSE 8080

CMD ["npm", "run", "start:prod"]
