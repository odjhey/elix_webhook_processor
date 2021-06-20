FROM elixir:1.12-alpine AS app_builder

ARG ENV=prod
ENV MIX_ENV=$ENV

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Create the application build directory
RUN mkdir /app
WORKDIR /app

# Make better strategy on copying files
COPY bin ./bin
COPY config ./config
COPY lib ./lib
COPY test ./test
COPY .formatter.exs ./.formatter.exs
COPY mix.exs ./mix.exs
COPY mix.lock ./mix.lock
COPY README.md ./README.md

# Fetch the application dependencies and build the application
RUN mix deps.get
RUN mix deps.compile
# RUN mix phx.digest
RUN mix release

# CMD ["/app/_build/prod/rel/prod/bin/prod", "start"]
# EXPOSE 8080

# ---- Application Stage ----
FROM alpine AS app

ENV LANG=C.UTF-8

# Install openssl
RUN apk update && apk add openssl libgcc libstdc++ ncurses-libs

# Copy over the build artifact from the previous step and create a non root user
RUN adduser -h /home/app -D app
WORKDIR /home/app
COPY --from=app_builder /app/_build .
RUN chown -R app: ./prod
USER app

CMD ["./prod/rel/prod/bin/prod", "start"]
EXPOSE 8080
