import { createRouter, createWebHistory } from "vue-router";
import DashboardView from "../views/DashboardView.vue";
import LoginView from "../views/LoginView.vue";
import ProfileView from "../views/ProfileView.vue";
import RegisterView from "../views/RegisterView.vue";
import ValidateTimeView from "../views/ValidateTimeView.vue";
import EditProfileView from "../views/EditProfileView.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "home",
      component: DashboardView,
    },
    {
      path: "/profile",
      name: "about",
      component: ProfileView,
    },
    {
      path: "/editprofile",
      name: "editprofile",
      component: EditProfileView,
    },
    {
      path: "/login",
      name: "login",
      component: LoginView,
    },
    {
      path: "/create-account",
      name: "register",
      component: RegisterView,
    },
    {
      path: "/validate-time",
      name: "validate-time",
      component: ValidateTimeView,
    },
  ],
});

export default router;
