<script setup lang="ts">
import { ref } from "vue";
import myImage from "../assets/Logo-GoTime.png";
import DeleteLogoutOverlay from "./overlay/DeleteLogoutOverlay.vue";
import { useRouter } from "vue-router";
import { useUserStore } from '@/stores/user';
import { routeNames } from '@/router/index';
import { errorHandling } from "@/utils/utils";
import { useSnackbarStore } from "@/stores/snackbar";

const router = useRouter();
const logoutPopupVisible = ref(false);
const userStore = useUserStore();
const snackbarStore = useSnackbarStore();
const apiUrl = import.meta.env.VITE_API_URL;

const logout = () => {
  logoutUser()
};

async function logoutUser() {
  const response = await fetch(`${apiUrl}/api/users/log_out`, {
    method: "DELETE",
    credentials: "include",
    headers: {
      "Content-Type": "application/json",
    },
  });
  if (!response.ok) {
    errorHandling(response, snackbarStore, router, userStore.logoutUser);
    return;
  }
  userStore.logoutUser();
  snackbarStore.showSnackbar('Logged out successfully', 2000, 'success');
  router.push({name : routeNames.login})
}
</script>

<template>
  <DeleteLogoutOverlay
    ref="popup1"
    title="Logout"
    description="Are you sure you want to logout"
    @action="logout"
    v-model:visible="logoutPopupVisible"
    v-if="logoutPopupVisible"
  />
  <v-navigation-drawer expand-on-hover rail>
    <v-list>
      <v-list-item :prepend-avatar="myImage" title="GoTime"></v-list-item>
    </v-list>

    <v-divider></v-divider>

    <v-list density="compact" nav>
      <v-list-item
        @click="router.push({ name: routeNames.home })"
        prepend-icon="mdi-view-dashboard-outline"
        title="Dashboard"
      ></v-list-item>
      <v-list-item
        @click="router.push({ name: routeNames.profile })"
        prepend-icon="mdi-account-outline"
        title="Profile"
      ></v-list-item>
      <v-list-item
        @click="router.push({ name: routeNames.manager })"
        prepend-icon="mdi-account-group-outline"
        title="Manage Team"
      ></v-list-item>
      <!-- TODO: open create team overlay -->
      <v-list-item
        @click="router.push({ name: routeNames.createTeam })"
        prepend-icon="mdi-account-multiple-plus-outline"
        title="Create Team"
      ></v-list-item>
      <v-list-item
        @click="router.push({ name: routeNames.register })"
        prepend-icon="mdi-account-plus-outline"
        title="Add employee"
      ></v-list-item>
      <v-list-item
        @click="router.push({ name: routeNames.validateTime })"
        prepend-icon="mdi-account-check-outline"
        title="Approve Time"
      ></v-list-item>
      <v-list-item
        @click="logoutPopupVisible = true"
        prepend-icon="mdi-logout"
        title="Disconnect"
      ></v-list-item>
    </v-list>
  </v-navigation-drawer>
</template>
