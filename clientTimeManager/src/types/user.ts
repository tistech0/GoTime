/**
 * This interface represent the user data stored in pinia
 */
export interface User {
  id: string;
  username: string;
  email: string;
  role: string;
  role_id: string;
  time_contract: number;
  password: string;
  confirm_password: string;
}
