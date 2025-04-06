# Utilizes Secure Chainguard Base Images
FROM cgr.dev/chainguard/go AS build

WORKDIR /app
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN go build -o /app/smtprelay ./

FROM cgr.dev/chainguard/bash:latest AS run
WORKDIR /app
COPY --from=build /app/smtprelay .
COPY smtprelay.ini .

EXPOSE 25
LABEL \
    name="go-smtprelay" \
    version="1.0.0" \
    description="Simple SMTP Relay"
USER mail
HEALTHCHECK --interval=60s --timeout=30s --start-period=15s --retries=3 CMD echo quit | curl -s telnet://127.0.0.1:25 > /dev/null

ENTRYPOINT ["./smtprelay"]