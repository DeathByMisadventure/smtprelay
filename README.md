# smtprelay

[![Go Report Card](https://goreportcard.com/badge/github.com/decke/smtprelay)](https://goreportcard.com/report/github.com/decke/smtprelay)
[![OpenSSF Scorecard](https://img.shields.io/ossf-scorecard/github.com/decke/smtprelay?label=openssf%20scorecard&style=flat)](https://scorecard.dev/viewer/?uri=github.com/decke/smtprelay)

Simple Golang based SMTP relay/proxy server that accepts mail via SMTP
and forwards it directly to another SMTP server.


## Why another SMTP server?

Outgoing mails are usually send via SMTP to an MTA (Mail Transfer Agent)
which is one of Postfix, Exim, Sendmail or OpenSMTPD on UNIX/Linux in most
cases. You really don't want to setup and maintain any of those full blown
kitchensinks yourself because they are complex, fragile and hard to
configure.

My use case is simple. I need to send automatically generated mails from
cron via msmtp/sSMTP/dma, mails from various services and network printers
via a remote SMTP server without giving away my mail credentials to each
device which produces mail.


## Main features

* Simple configuration with ini file .env file or environment variables
* Supports SMTPS/TLS (465), STARTTLS (587) and unencrypted SMTP (25)
* Checks for sender, receiver, client IP
* Authentication support with file (LOGIN, PLAIN)
* Enforce encryption for authentication
* Forwards all mail to a smarthost (any SMTP server)
* Small codebase
* IPv6 support

## Docker Container Image

The image uses [Chainguard](https://www.chainguard.dev/) secure images.

Options from the [smtprelay.ini](smtprelay.ini) file should be passed as environmental vasriables, prefixed with SMTPRELAY_ as shown in the example. Utilizing a .env file is also a good way to pass values.

SMTPRELAY_REMOTES is required to be set to a forwarding server otherwise emails are simply discarded.

To run an smtprelay container that relays to gmail smtp servers, listening on port 10025:

```bash
docker run -e SMTPRELAY_REMOTES='starttls://user@gmail.com:passwordtoken@smtp.gmail.com:587' -p 10025:25 ghcr.io/deathbymisadventure/smtprelay:latest
```
