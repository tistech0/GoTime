import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'eu.gotime',
  appName: 'GoTime',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  }
};

export default config;
