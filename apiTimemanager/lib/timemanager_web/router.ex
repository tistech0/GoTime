defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  import TimemanagerWeb.UserAuth

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
    plug(:fetch_current_user)
  end

  @moduledoc """
    API routes for TimemanagerWeb.

     ## Routes

    # Routes for working times
    - `GET /api/workingtimes/`: Returns a list of all working times. (Role: superadmin)
    - `GET /api/workingtimes/:userID/:id`: Returns the working times for a specific user by ID. (Role: user)
    - `GET /api/workingtimes/:userID`: Returns the working times for a specific user by ID within a specific start and end time. (Role: user)
    - `POST /api/workingtimes/:userID`: Creates a new working time entry for a specific user by ID. (Role: user)
    - `DELETE /api/workingtimes/:id`: Deletes a specific working time entry by ID. (Role: user)
    - `PUT /api/workingtimes/:id`: Updates a specific working time entry by ID. (Role: user)

    # Routes for teams
    - `GET /api/teams/`: Returns a list of all teams. (Role: admin)
    - `GET /api/teams/:teamID`: Returns the team for a specific teamID. (Role: admin)
    - `GET /api/teams/:userID`: Returns the team link manager for a specific userID. (Role: superadmin)
    - `POST /api/teams/`: Creates a new team. (Role: admin)
    - `PUT /api/teams/:teamID`: Updates a specific team by teamID. (Role: admin)
    - `DELETE /api/teams/:teamID`: Deletes a specific team by teamID. (Role: admin)
    - `GET /api/teams/manage`: Returns the teams managed by the current user. (Role: admin)

    # Routes for team users
    - `GET /api/teamUser/:userID`: Returns the team link member for a specific userID. (Role: admin)
    - `POST /api/teamUser/`: Creates a new team user. (Role: admin)

    # Routes for clocks
    - `GET /api/clocks/:userID`: Returns the clock for a specific userID. (Role: user)
    - `POST /api/clocks/:userID`: Creates or updates the clock for a specific userID. (Role: user)

    # Routes for authentication
    - `POST /api/users/log_in`: Logs in a user. (No authentication required)
    - `DELETE /api/users/log_out`: Logs out a user. (No authentication required)

    # Routes for users
    - `GET /api/users/`: Returns the user by email and username. (Role: admin)
    - `GET /api/users/:userID`: Returns the user for a specific userID. (Role: user)
    - `POST /api/users/`: Registers a new user. (Role: admin)
    - `PUT /api/users/:userID`: Updates a specific user by userID. (Role: user)
    - `PATCH /api/users/:userID`: Updates the user role for a specific userID. (Role: admin)
    - `DELETE /api/users/:userID`: Deletes a specific user by userID. (Role: admin)

    # Routes for roles
    - `GET /api/roles/`: Returns a list of all roles. (Role: admin)

    # Stats routes
    - `GET /api/stats/team/workingtimes/all/:teamID`: Returns all working times for a specific team within a start and end time. (Role: admin)
    - `GET /api/stats/team/workingtimes/average/:teamID`: Returns the average working hours per day for a specific team within a start and end time. (Role: admin)
  """

  ## Working Times routes

  scope "/api/workingtimes", TimemanagerWeb do
    pipe_through([:api, :require_authenticated_user])

    get("/:userID/:id", WorkingTimesController, :getWithUserId)
    get("/:userID", WorkingTimesController, :getWithStartEndUser, [:start, :end])
    post("/:userID", WorkingTimesController, :create)
    delete("/:id", WorkingTimesController, :delete)
    put("/:id", WorkingTimesController, :update)

    pipe_through([:require_admin_role, :require_super_admin_role])

    get("/", WorkingTimesController, :index)
  end

  ## Team routes

  scope "/api/teams/manage", TimemanagerWeb do
    pipe_through([:api, :require_authenticated_user, :require_admin_role])
    get("/", TeamController, :get_Team_Current_User_Manager)
  end

  scope "/api/teams", TimemanagerWeb do
    pipe_through([:api, :require_authenticated_user, :require_admin_role])
    get("/", TeamController, :index)
    get("/:teamID", TeamController, :show)
    post("/", TeamController, :create)
    put("/:teamID", TeamController, :update)
    delete("/:teamID", TeamController, :delete)

    pipe_through([:require_super_admin_role])
    get("/:userID", TeamController, :getTeamLinkManager)
  end

  ## Team user routes

  scope "/api/teamUser", TimemanagerWeb do
    pipe_through([:api, :require_authenticated_user, :require_admin_role])

    get("/:userID", Team_userController, :getTeamLinkMember)
    post("/", Team_userController, :create)
  end

  # Clocks routes

  scope "/api/clocks", TimemanagerWeb do
    pipe_through([:api, :require_authenticated_user])

    get("/:userID", ClockController, :show)
    post("/:userID", ClockController, :createOrUpdate)
  end

  ## User routes

  scope "/api/users", TimemanagerWeb do
    # Routes access with basic rights
    pipe_through([:api])
    post("/log_in", UserSessionController, :create)

    pipe_through([:require_authenticated_user])

    get("/:userID", UserController, :show)
    put("/:userID", UserController, :update)
    delete("/log_out", UserSessionController, :delete)

    # Routes with admin rights. More control to make in the controller.
    pipe_through([:require_admin_role])

    get("/", UserController, :get_user_by_email_and_username, [:email, :username])
    post("/", UserController, :register)
    patch("/:userID", UserController, :update_user_role, [:role])
    delete("/:userID", UserController, :delete)
  end

  ## Role routes

  scope "/api/roles", TimemanagerWeb do
    pipe_through([:api, :require_authenticated_user, :require_admin_role])

    get("/", RoleController, :get_roles_list_for_current_user)
  end

  ## Stats routes
  scope "/api/stats/team/workingtimes/all", TimemanagerWeb do
    pipe_through([:api, :require_authenticated_user, :require_admin_role])

    get("/:teamID", WorkingTimesController, :getWithStartEndTeam, [:start, :end])
  end

  scope "/api/stats/team/workingtimes/average", TimemanagerWeb do
    pipe_through([:api, :require_authenticated_user, :require_admin_role])

    get("/:teamID", WorkingTimesController, :getTeamAverageHoursPerDay, [:start, :end])
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
