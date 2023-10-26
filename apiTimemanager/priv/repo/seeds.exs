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
    role: "Admin"
  },
  %{
    role: "User"
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
>>>>>>> 545d6e8614c11759e27c9a4ba33aba979e2d95fa
end)
