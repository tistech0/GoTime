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
