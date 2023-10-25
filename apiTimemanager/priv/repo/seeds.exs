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
alias Timemanager.Account.User

# Delete all existing roles
Repo.delete_all(Role)

# List of roles to be inserted
roles_list = [
  %{
    id: 1,
    role: "Admin"
  },
  %{
    id: 2,
    role: "User"
  },
  %{
    id: 3,
    role: "SuperAdmin"
  }
]

Enum.each(roles_list, fn role ->
  role_changeset = Role.changeset(%Role{}, role)
  Repo.insert!(role_changeset)
end)

Repo.delete_all(User)

# List of user data for three users
user_data_list = [
  %{
    username: "user1",
    email: "user1@example.com",
    password: "password1",
    time_contract: 40,
    # Assign the first role (Admin)
    role_id: Enum.at(roles_list, 0).id
  },
  %{
    username: "user2",
    email: "user2@example.com",
    password: "password2",
    time_contract: 30,
    # Assign the second role (User)
    role_id: Enum.at(roles_list, 1).id
  },
  %{
    username: "user3",
    email: "user3@example.com",
    password: "password3",
    time_contract: 20,
    # Assign the third role (SuperAdmin)
    role_id: Enum.at(roles_list, 2).id
  }
]

# Insert users into the User table
Enum.each(user_data_list, fn user_data ->
  user_changeset = User.changeset(%User{}, user_data)
  Repo.insert!(user_changeset)
end)
