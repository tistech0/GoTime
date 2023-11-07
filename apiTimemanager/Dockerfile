# Use the official Elixir image as a base
FROM elixir:latest

# Set the working directory inside the container
WORKDIR ./app

# Copy the rest of the application code to the container
COPY . .

# Make the entrypoint script executable
RUN chmod +x ./entrypoint.sh

# Set the entrypoint script as the container's entrypoint
ENTRYPOINT ["./entrypoint.sh"]

# Install hex and rebar
RUN mix local.hex --force && mix local.rebar --force

# Install project dependencies
RUN mix do deps.get, deps.update --all, deps.compile

# Expose the Phoenix port
EXPOSE 4000

ENV MIX_ENV=dev \
    DATABASE_NAME=timemanager_dev \
    DATABASE_USERNAME=postgres \
    POSTGRES_PASSWORD=${DATABASE_PASSWORD} \
    DATABASE_HOSTNAME=postgres-service