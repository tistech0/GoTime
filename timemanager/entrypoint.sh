#!/bin/sh

# Run Ecto migrations
mix ecto.migrate role

# Run the Phoenix app
mix phx.server

# Start the Phoenix app
exec "$@"

