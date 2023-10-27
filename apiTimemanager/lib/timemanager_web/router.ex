defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  import TimemanagerWeb.UserAuth

  pipeline :api do
    plug(:accepts, ["json"])
    plug :fetch_session
    plug :fetch_current_user
  end


  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timemanager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: TimemanagerWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

    ## Authentication routes

    scope "/api/users", TimemanagerWeb do
      pipe_through [:api, :redirect_if_user_is_authenticated]

      post("/log_in", UserSessionController, :create)
    end

    scope "/api", TimemanagerWeb do
      pipe_through [:api]

      delete("/users/log_out", UserSessionController, :delete)
    end

    ## User routes

    scope "/api/users", TimemanagerWeb do
      pipe_through [:api, :require_authenticated_user]

      get("/", UserController, :get_user_by_email_and_username, [:email, :username])
      get("/:userID", UserController, :show)
      post("/", UserController, :register)
      put("/:userID", UserController, :update)
      delete("/:userID", UserController, :delete)

    end

    ## Role routes

    scope "/api", TimemanagerWeb do
      pipe_through [:api, :require_authenticated_user]

      get "/roles", RoleController, :index
    end

end
