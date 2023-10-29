defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  import TimemanagerWeb.UserAuth

  pipeline :api do
    plug(:accepts, ["json"])
    plug :fetch_session
    plug :fetch_current_user
  end

  ## Working Times routes

  scope "/api/workingtimes", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get("/", WorkingTimeController, :index)
    get("/:userID/:id", WorkingTimesController, :getWithUserId)
    get("/:userID", WorkingTimesController, :getWithStartEnd, [:start, :end])
    post("/:userID", WorkingTimesController, :create)
    delete("/:id", WorkingTimesController, :delete)
    put("/:id", WorkingTimesController, :update)
  end

  ## Team routes

  scope "/api/teams", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get "/", TeamController, :index
    get "/:teamID", TeamController, :show
    get "/:userID", TeamController, :getTeamLinkManager
    delete "/:teamID", TeamController, :delete
  end

  ## Team user routes

  scope "/api/teamUser", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get "/:userID", Team_userController, :getTeamLinkMember
  end

  # Clocks routes

  scope "/api/clocks", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get("/:userID", ClockController, :show)
    post("/:userID", ClockController, :createOrUpdate)
  end

  ## Authentication routes

  scope "/api/users", TimemanagerWeb do
    pipe_through [:api, :redirect_if_user_is_authenticated]

    post("/log_in", UserSessionController, :create)
  end

  scope "/api/users", TimemanagerWeb do
    pipe_through [:api]

    delete("/log_out", UserSessionController, :delete)
  end

  ## User routes

  scope "/api/users", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get("/", UserController, :get_user_by_email_and_username, [:email, :username])
    get("/:userID", UserController, :show)
    post("/", UserController, :register)
    put("/:userID", UserController, :update)
    patch("/:userID", UserController, :update_user_role, [:role])
    delete("/:userID", UserController, :delete)
  end

  ## Role routes

  scope "/api/roles", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get "/", RoleController, :index
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
end
