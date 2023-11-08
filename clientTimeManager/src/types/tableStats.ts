export interface TableStats {
  id: string;
  start: Date;
  status: string;
  end: Date;
  valueDay: number;
  valueNight: number;
  user: {
    id: string;
    username: string;
  };
}
