defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  import TimemanagerWeb.UserAuth

  pipeline :api do
    plug(:accepts, ["json"])
    plug :fetch_session
    plug :fetch_current_user
  end
@moduledoc """
  API routes for TimemanagerWeb.

   ## Routes

  # Routes for working times
  - `GET /api/workingtimes/`: Returns a list of all working times.
  - `GET /api/workingtimes/:userID/:id`: Returns the working times for a specific user by ID.
  - `GET /api/workingtimes/:userID`: Returns the working times for a specific user by ID within a specific start and end time.
  - `POST /api/workingtimes/:userID`: Creates a new working time entry for a specific user by ID.
  - `DELETE /api/workingtimes/:id`: Deletes a specific working time entry by ID.
  - `PUT /api/workingtimes/:id`: Updates a specific working time entry by ID.

  # Routes for teams
  - `GET /api/teams/`: Returns a list of all teams.
  - `GET /api/teams/:teamID`: Returns the team for a specific teamID.
  - `GET /api/teams/:userID`: Returns the team link manager for a specific userID.
  - `POST /api/teams/`: Creates a new team.
  - `PUT /api/teams/:teamID`: Updates a specific team by teamID.
  - `DELETE /api/teams/:teamID`: Deletes a specific team by teamID.

  # Routes for team users
  - `GET /api/teamUser/:userID`: Returns the team link member for a specific userID.
  - `POST /api/teamUser/`: Creates a new team user.

  # Routes for clocks
  - `GET /api/clocks/:userID`: Returns the clock for a specific userID.
  - `POST /api/clocks/:userID`: Creates or updates the clock for a specific userID.

  # Routes for authentication
  - `POST /api/users/log_in`: Logs in a user.
  - `DELETE /api/users/log_out`: Logs out a user.

  # Routes for users
  - `GET /api/users/`: Returns the user by email and username.
  - `GET /api/users/:userID`: Returns the user for a specific userID.
  - `POST /api/users/`: Registers a new user.
  - `PUT /api/users/:userID`: Updates a specific user by userID.
  - `PATCH /api/users/:userID`: Updates the user role for a specific userID.
  - `DELETE /api/users/:userID`: Deletes a specific user by userID.

  # Routes for roles
  - `GET /api/roles/`: Returns a list of all roles.
"""

  ## Working Times routes

  scope "/api/workingtimes", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get("/", WorkingTimeController, :index)
    get("/:userID/:id", WorkingTimesController, :getWithUserId)
    get("/:userID", WorkingTimesController, :getWithStartEndUser, [:start, :end])
    post("/:userID", WorkingTimesController, :create)
    delete("/:id", WorkingTimesController, :delete)
    put("/:id", WorkingTimesController, :update)
  end


  ## Team routes

  scope "/api/teams/manage", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user, :require_admin_role]
    get("/", TeamController, :get_Team_Current_User_Manager)

  end


  scope "/api/teams", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get("/", TeamController, :index)
    get("/:teamID", TeamController, :show)
    post("/", TeamController, :create)
    put("/:teamID", TeamController, :update)
    delete("/:teamID", TeamController, :delete)

    pipe_through [:require_super_admin_role]

    get("/:userID", TeamController, :getTeamLinkManager)
  end

  ## Team user routes

  scope "/api/teamUser", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get("/:userID", Team_userController, :getTeamLinkMember)
    post("/", Team_userController, :create)
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
# Routes access with basic rights
    pipe_through [:api, :require_authenticated_user]

    get("/:userID", UserController, :show)
    put("/:userID", UserController, :update)

    # Routes with admin rights. More control to make in the controller.
    pipe_through [:require_admin_role]

    get("/", UserController, :get_user_by_email_and_username, [:email, :username])
    post("/", UserController, :register)
    patch("/:userID", UserController, :update_user_role, [:role])
    delete("/:userID", UserController, :delete)
  end

  ## Role routes

  scope "/api/roles", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get("/", RoleController, :get_roles_list_for_current_user)
  end

  ## Stats routes
  scope "/api/stats/team/workingtimes/all", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

    get("/:teamID", WorkingTimesController, :getWithStartEndTeam, [:start, :end])
  end

  scope "/api/stats/team/workingtimes/average", TimemanagerWeb do
    pipe_through [:api, :require_authenticated_user]

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
