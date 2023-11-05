defmodule RoleEnum do
  import SimpleEnum, only: [defenum: 2]

  @doc """
    This enum defines all the possible role values.
  """
  defenum :role, user_role: "User", admin_role: "Admin", super_admin_role: "SuperAdmin"
end
