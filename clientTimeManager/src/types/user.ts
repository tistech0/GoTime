/**
 * This interface represent the user data stored in pinia
 */
export interface User {
  id: string;
  username: string;
  email: string;
  role: "User" | "Admin" | "SuperAdmin";
  time_contract: number;
}
