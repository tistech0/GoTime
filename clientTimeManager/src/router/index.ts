import { createRouter, createWebHistory } from "vue-router";
import DashboardView from "../views/DashboardView.vue";
import LoginView from "../views/LoginView.vue";
import ProfileView from "../views/ProfileView.vue";
import ValidateTimeView from "../views/ValidateTimeView.vue";
import EditProfileView from "../views/EditProfileView.vue";
import RegisterView from "@/views/RegisterView.vue";
import { useUserStore } from '@/stores/user';
import { Role } from '../constants/RoleEnum'

const routeNames = {
  home: 'home',
  login: 'login',
  register: 'register',
  profile: 'about',
  editProfile: 'editprofile',
  validateTime: 'validate-time'
}

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
      path: "/validate-time",
      name: routeNames.validateTime,
      component: ValidateTimeView,
    },
  ],
});

// Make some checks before allowing routes redirections
router.beforeEach((to, from) => {

  // Fetch from localstorage
  const userStore = useUserStore();

  const isAuthenticated = userStore.isAuthenticated;

  // Check the user is connected otherwise redirect to login
  if (!isAuthenticated && to.name !== routeNames.login) { // Need to specify with name different than login or there will be an infinity loop
    return { name: routeNames.login }
  }

  // Check user roles and grant access or not to pages
  const currentUserRole = userStore.user
  if(currentUserRole != null && currentUserRole.role == Role.User) {
    switch(to.name) {
      case 'otherRouteToRestrict': // Write real routes to also redirect to home when wrong access.
      case routeNames.register: {
        return { name: routeNames.home };
      }
    }
  }
});

export default router;
