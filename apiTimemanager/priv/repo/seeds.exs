# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Timemanager.Repo.insert!(%Timemanager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Timemanager.Repo
alias Timemanager.Roles.Role

# List of roles to be inserted
roles_list = [
  %{
    role: "User"
  },
  %{
    role: "Admin"
  },
  %{
    role: "SuperAdmin"
  }
]

Enum.each(roles_list, fn role ->
  # Check if the role already exists in the database
  existing_role = Repo.get_by(Role, role)

  case existing_role do
    nil ->
      # If the role doesn't exist, create it
      role_changeset = Role.changeset(%Role{}, %{role: role.role})
      Repo.insert!(role_changeset)
    _ ->
      # Role already exists, do nothing
      IO.puts("Role '#{role.role}' already exists.")
  end
end)

# List of users to be inserted
users_list = [
  %{
    username: "admin",
    email: "admin@email.com",
    password: "admin",
    time_contract: 40,
    role_id: 1
  },
  %{
    username: "user",
    email: "user@email.com",
    password: "user",
    time_contract: 35,
    role_id: 2
  },
  %{
    username: "superadmin",
    email: "superadmin@email.com",
    password: "superadmin",
    time_contract: 40,
    role_id: 3
  }
]

Enum.each(users_list, fn user ->
  # Check if the user already exists in the database
  existing_user = Repo.get_by(Timemanager.Account.User, user)

  case existing_user do
    nil ->
      # If the user doesn't exist, create it
      user_changeset = Timemanager.Account.User.changeset(%Timemanager.Account.User{}, user)
      Repo.insert!(user_changeset)
    _ ->
      # User already exists, do nothing
      IO.puts("User '#{user.username}' already exists.")
  end
end)

# List of working_times to be inserted
working_times_list = [
  %{
    start: "2023-10-25 20:48:13",
    end: "2023-10-25 20:48:37",
    user_id: 1
  },
  %{
    start: "2023-11-25 09:23:45",
    end: "2023-11-25 18:30:31",
    user_id: 1
  },
  %{
    start: "2023-12-25 10:21:25",
    end: "2023-12-25 17:49:56",
    user_id: 1
  },
  %{
    start: "2023-10-25 20:48:13",
    end: "2023-10-25 20:48:37",
    user_id: 2
  },
  %{
    start: "2023-11-25 09:23:45",
    end: "2023-11-25 18:30:31",
    user_id: 2
  },
  %{
    start: "2023-12-25 10:21:25",
    end: "2023-12-25 17:49:56",
    user_id: 2
  },
  %{
    start: "2023-10-25 20:48:13",
    end: "2023-10-25 20:48:37",
    user_id: 3
  },
  %{
    start: "2023-11-25 09:23:45",
    end: "2023-11-25 18:30:31",
    user_id: 3
  },
  %{
    start: "2023-12-25 10:21:25",
    end: "2023-12-25 17:49:56",
    user_id: 3
  },
]

Enum.each(working_times_list, fn working_time ->
  # Check if the working_time already exists in the database

  existing_working_time = Repo.get_by(Timemanager.Time.WorkingTimes, working_time)

  case existing_working_time do
    nil ->
      # If the working_time doesn't exist, create it
      working_time_changeset = Timemanager.Time.WorkingTimes.changeset(%Timemanager.Time.WorkingTimes{}, working_time)
      Repo.insert!(working_time_changeset)
    _ ->
      # Working_time already exists, do nothing
      IO.puts("Working_time '#{working_time.start_time}' already exists.")
  end
end)

# List of Clock to be inserted
clocks_list = [
  %{
    time: "2023-10-25 20:48:13",
    status: false,
    user_id: 1
  },
  %{
    time: "2023-11-25 09:23:45",
    status: true,
    user_id: 2
  },
  %{
    time: "2023-12-25 10:21:25",
    status: false,
    user_id: 3
  }
]

Enum.each(clocks_list, fn clock ->
  # Check if the clock already exists in the database

  existing_clock = Repo.get_by(Timemanager.Time.Clock, clock)

  case existing_clock do
    nil ->
      # If the clock doesn't exist, create it
      clock_changeset = Timemanager.Time.Clock.changeset(%Timemanager.Time.Clock{}, clock)
      Repo.insert!(clock_changeset)
    _ ->
      # Clock already exists, do nothing
      IO.puts("Clock '#{clock.time}' already exists.")
  end
end)

#List of teams to be inserted
teams_list = [
  %{
    name: "Team 1",
    manager_id: 2
  },
  %{
    name: "Team 2",
    manager_id: 3
  }
]

Enum.each(teams_list, fn team ->
  # Check if the team already exists in the database

  existing_team = Repo.get_by(Timemanager.Teams.Team, team)

  case existing_team do
    nil ->
      # If the team doesn't exist, create it
      team_changeset = Timemanager.Teams.Team.changeset(%Timemanager.Teams.Team{}, team)
      Repo.insert!(team_changeset)
    _ ->
      # Team already exists, do nothing
      IO.puts("Team '#{team.name}' already exists.")
  end
end)

#List of team_members to be inserted
team_members_list = [
  %{
    team_id: 1,
    user_id: 1
  },
  %{
    team_id: 1,
    user_id: 3
  },
  %{
    team_id: 2,
    user_id: 1
  },
  %{
    team_id: 2,
    user_id: 2
  }
]

Enum.each(team_members_list, fn team_member ->
  # Check if the team_member already exists in the database

  existing_team_member = Repo.get_by(Timemanager.Team.Team_user, team_member)

  case existing_team_member do
    nil ->
      # If the team_member doesn't exist, create it
      team_member_changeset = Timemanager.Team.Team_user.changeset(%Timemanager.Team.Team_user{}, team_member)
      Repo.insert!(team_member_changeset)
    _ ->
      # Team_member already exists, do nothing
      IO.puts("Team_member '#{team_member.team_id}' already exists.")
  end
end)
