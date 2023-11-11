import { createRouter, createWebHistory } from "vue-router";
import DashboardView from "../views/DashboardView.vue";
import LoginView from "../views/LoginView.vue";
import RegisterView from "@/views/RegisterView.vue";
import ProfileView from "../views/ProfileView.vue";
import ValidateTimeView from "../views/ValidateTimeView.vue";
import EditProfileView from "../views/EditProfileView.vue";
import DashboardManagerViewVue from "@/views/DashboardManagerView.vue";
import CreateTeamView from "../views/CreateTeamView.vue";
import { useUserStore } from "@/stores/user";
import { Role } from "../constants/RoleEnum";

export const routeNames = {
  home: "home",
  login: "login",
  register: "register",
  profile: "about",
  editProfile: "editprofile",
  validateTime: "validate-time",
  validateTimeUser: "validate-time/:id",
  userLook: "user-look/:id",
};

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: routeNames.home,
      component: DashboardView,
    },
    {
      path: "/profile",
      name: routeNames.profile,
      component: ProfileView,
    },
    {
      path: "/editprofile",
      name: routeNames.editProfile,
      component: EditProfileView,
    },
    {
      path: "/login",
      name: routeNames.login,
      component: LoginView,
    },
    {
      path: "/create-account",
      name: routeNames.register,
      component: RegisterView,
    },
    {
      path: "/manager",
      name: "manager",
      component: DashboardManagerViewVue,
    },
    {
      path: "/validate-time",
      name: routeNames.validateTime,
      component: ValidateTimeView,
    },
    {
      path: "/user-look/:id",
      name: routeNames.userLook,
      component: DashboardView,
    },
    {
      path: "/validate-time/:id",
      name: routeNames.validateTimeUser,
      component: ValidateTimeView,
    },
  ],
});

// Make some checks before allowing routes redirections
router.beforeEach((to, from) => {
  // Fetch from localstorage
  const userStore = useUserStore();

  const isAuthenticated = userStore.isAuthenticated;
  const currentUser = userStore.user;

  // Check the user is connected otherwise redirect to login
  if (
    (!isAuthenticated || currentUser == null) &&
    to.name !== routeNames.login
  ) {
    // Need to specify with name different than login or there will be an infinity loop
    return { name: routeNames.login };
  }

  // Redirect to home if trying to login when already logged in
  if (isAuthenticated && currentUser != null && to.name === routeNames.login) {
    return { name: routeNames.home };
  }

  // Check user roles and grant access or not to pages

  // Get the role enum value
  const userRoleEnumValue = Role[currentUser?.role as keyof typeof Role];

  if (userRoleEnumValue != Role.Admin && userRoleEnumValue != Role.SuperAdmin) {
    switch (to.name) {
      case "otherRouteToRestrict": // Write real routes to also redirect to home when wrong access.
      case routeNames.register: {
        return { name: routeNames.home };
      }
    }
  }
});

export default router;
