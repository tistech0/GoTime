#!/bin/sh

# Run Ecto migrations
mix ecto.migrate

mix run priv/repo/seeds.exs

# Seed the database
mix run priv/repo/seeds.exs

# Run the Phoenix app
mix phx.server

# Start the Phoenix app
exec "$@"

