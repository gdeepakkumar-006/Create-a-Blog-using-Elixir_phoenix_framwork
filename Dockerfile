FROM elixir:1.12.2-alpine

RUN apk update && \
  apk add alpine-sdk && \
  apk add postgresql-client inotify-tools

RUN addgroup -g 1000 elixir \
  && adduser -u 1000 -G elixir -s /bin/bash -D elixir

USER elixir

RUN mix local.hex --force && \
  mix archive.install hex phx_new 1.6.2 --force && \
  mix local.rebar --force

WORKDIR /home/elixir/backend