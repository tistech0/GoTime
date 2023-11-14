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

# Map of roles to be used in the users list
roles_uuids = %{
  "User" => Repo.get_by(Role, role: "User").id,
  "Admin" => Repo.get_by(Role, role: "Admin").id,
  "SuperAdmin" => Repo.get_by(Role, role: "SuperAdmin").id
}

# List of users to be inserted
users_list = [
  %{
    username: "admin",
    email: "admin@email.com",
    hashed_password: Bcrypt.hash_pwd_salt("admin"),
    time_contract: 40.0,
    role_id: roles_uuids["Admin"]
  },
  %{
    username: "user",
    email: "user@email.com",
    hashed_password: Bcrypt.hash_pwd_salt("user"),
    time_contract: 35.0,
    role_id: roles_uuids["User"]
  },
  %{
    username: "superadmin",
    email: "superadmin@email.com",
    hashed_password: Bcrypt.hash_pwd_salt("superadmin"),
    time_contract: 40,
    role_id: roles_uuids["SuperAdmin"]
  },
  %{
    username: "Coline Juriot",
    email: "colineJuriot@email.com",
    hashed_password: Bcrypt.hash_pwd_salt("colineJuriot"),
    time_contract: 40,
    role_id: roles_uuids["SuperAdmin"]
  }
]

Enum.each(users_list, fn user ->
  # Check if the user already exists in the database
  existing_user = Repo.get_by(Timemanager.Account.User, username: user.username)

  case existing_user do
    nil ->
      # If the user doesn't exist, create it
      user_changeset = Timemanager.Account.User.seeds_changeset(%Timemanager.Account.User{}, user)
      Repo.insert!(user_changeset)

    _ ->
      # User already exists, do nothing
      IO.puts("User '#{user.username}' already exists.")
  end
end)

