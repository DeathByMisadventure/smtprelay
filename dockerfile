# Utilizes Secure Chainguard Base Images
FROM cgr.dev/chainguard/go AS build

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o /app/smtprelay ./

FROM cgr.dev/chainguard/wolfi-base:latest AS run

RUN apk add --no-cache netcat-openbsd

LABEL \
    org.opencontainers.image.title="go-smtprelay" \
    org.opencontainers.image.description="Simple SMTP Relay" \
    org.opencontainers.image.version="1.0.0" \
    org.opencontainers.image.licenses="MIT"

WORKDIR /app
COPY --from=build /app/smtprelay .
COPY smtprelay.ini .

USER mail

HEALTHCHECK --interval=60s --timeout=30s --start-period=15s --retries=3 \
    CMD echo "QUIT" | nc 127.0.0.1 25 || exit 1
# Expose SMTP Port
EXPOSE 25
ENTRYPOINT ["./smtprelay"]
