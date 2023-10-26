defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", TimemanagerWeb do
    pipe_through(:api)

  end

  scope "/api/workingtimes", TimemanagerWeb do
    pipe_through(:api)

    get("/", WorkingTimeController, :index)
    get("/:userID/:id", WorkingTimesController, :getWithUserId)
    get("/:userID", WorkingTimesController, :getWithStartEnd, [:start, :end])
    post("/userID", WorkingTimesController, :create)
    delete("/:id", WorkingTimesController, :delete)
  end

  scope "/api/clocks", TimemanagerWeb do
    pipe_through(:api)

    get("/:userID", ClockController, :show)
    post("/:userID", ClockController, :create)
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
