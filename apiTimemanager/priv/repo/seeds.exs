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

# Delete all existing roles
Repo.delete_all(Role)

# List of roles to be inserted
roles = ["Admin", "User", "SuperAdmin"]

Enum.each(roles, fn role ->
  changeset = Role.changeset(%Role{}, %{role: role})
  Repo.insert!(changeset)
end)
