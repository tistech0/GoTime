import "./assets/main.css";
import "@mdi/font/css/materialdesignicons.css";

import { createApp } from "vue";
import { createPinia } from "pinia";

import App from "./App.vue";
import router from "./router";

// Vuetify
import "vuetify/styles";
import { createVuetify } from "vuetify";
import { aliases, mdi } from "vuetify/iconsets/mdi";
import * as components from "vuetify/components";
import * as directives from "vuetify/directives";

// ApexCharts
import VueApexCharts from "vue3-apexcharts";

const app = createApp(App);

const vuetify = createVuetify({
  components,
  directives,
  display: {
    mobileBreakpoint: "md",
    thresholds: {
      xs: 0,
      sm: 340,
      md: 540,
      lg: 800,
      xl: 1280,
    },
  },
  icons: {
    defaultSet: "mdi",
    aliases,
    sets: {
      mdi,
    },
  },
});

app.use(createPinia());
app.use(router);
app.use(vuetify);
app.use(VueApexCharts);

app.mount("#app");
