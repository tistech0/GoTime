#!/bin/sh

# Run Ecto migrations
mix ecto.migrate

# Run the Phoenix app
mix phx.server

# Start the Phoenix app
exec "$@"

