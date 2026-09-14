FROM node:24-alpine AS builder

WORKDIR /src/app

COPY package*.json ./

RUN npm ci

COPY tsconfig.json ./
COPY src ./src

RUN npm run build


FROM node:24-alpine AS production

WORKDIR /src/app

ENV NODE_ENV=production

COPY package*.json ./

RUN npm ci typescript@6 -D --omit=dev && \
    npm cache clean --force

COPY --from=builder /app/dist ./dist

RUN addgroup -S nodejs && \
    adduser -S nodejs -G nodejs

USER nodejs

EXPOSE 3000

CMD ["node", "dist/server.js"]