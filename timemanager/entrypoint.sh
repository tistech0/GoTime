#!/bin/sh

# Run Ecto migrations
mix ecto.migrate role

# Start the Phoenix app
exec "$@"

