import { createRouter, createWebHistory } from "vue-router";
import DashboardView from "../views/DashboardView.vue";
import LoginView from "../views/LoginView.vue";
import ProfileView from "../views/ProfileView.vue";
import EditProfileView from "../views/EditProfileView.vue";
import RegisterView from "@/views/RegisterView.vue";

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
  ],
});

export default router;
