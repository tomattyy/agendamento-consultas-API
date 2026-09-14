FROM node:24-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build


FROM node:24-alpine AS production

WORKDIR /src/app

ENV NODE_ENV=production

RUN npm install

COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/package*.json ./
COPY --from=builder /usr/src/app/dist ./dist

USER nodejs

EXPOSE 3000

CMD ["node", "src/server.js"]