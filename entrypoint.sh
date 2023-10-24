#!/bin/sh

# Run Ecto migrations
mix ecto.migrate

# Start the Phoenix app
exec "$@"
