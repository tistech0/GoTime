# Use the official Elixir image as a base
FROM elixir:latest

# Set the working directory inside the container
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy the mix.exs and mix.lock files to the container
COPY mix.exs mix.lock ./

# Install project dependencies
RUN mix do deps.get, deps.compile

RUN mix ecto.migrate

# Copy the rest of the application code to the container
COPY . .

# Expose the Phoenix port
EXPOSE 4000

# Start the Phoenix app
CMD ["mix", "phx.server"]

