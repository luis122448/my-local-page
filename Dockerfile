FROM node:20-alpine AS builder
WORKDIR /app
RUN npm install -g pnpm@9.15.4
COPY pnpm-lock.yaml package.json ./
RUN pnpm install
COPY . .
RUN pnpm build

FROM node:20-alpine AS runner
WORKDIR /app
RUN npm install -g pnpm@9.15.4
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json /app/pnpm-lock.yaml ./
COPY --from=builder /app/node_modules ./node_modules
CMD ["pnpm", "preview", "--host", "--port", "4321"]
EXPOSE 4321