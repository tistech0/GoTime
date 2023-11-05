defmodule RoleEnum do
  import SimpleEnum, only: [defenum: 2]

  defenum :role, user_role: "User", admin_role: "Admin", super_admin_role: "SuperAdmin"
end
