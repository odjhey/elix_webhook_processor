FROM elixir:1.12

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

# Fetch the application dependencies and build the application
RUN mix deps.get
RUN mix deps.compile
# RUN mix phx.digest
RUN mix release

CMD ["/app/_build/prod/rel/prod/bin/prod", "start"]

EXPOSE 8080

