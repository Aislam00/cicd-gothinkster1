FROM docker.io/node:lts-alpine

ENV HOST=0.0.0.0
ENV PORT=3000

WORKDIR /app

RUN apk add --no-cache openssl

RUN addgroup --system api && \
    adduser --system -G api api

COPY dist/api api
COPY src/prisma/schema.prisma api/src/prisma/schema.prisma
RUN chown -R api:api .

RUN npm --prefix api --omit=dev -f install

RUN cd api && npx prisma generate

USER api

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

CMD [ "node", "api" ]
