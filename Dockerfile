FROM node:24-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build


FROM node:24-alpine AS production

WORKDIR /src/app

ENV NODE_ENV=production

RUN npm ci --omit=dev

COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/dist ./dist

USER nodejs

EXPOSE 3000

CMD ["node", "src/server.js"]