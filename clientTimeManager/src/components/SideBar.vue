<script setup lang="ts">
import { ref } from "vue";
import myImage from "../assets/Logo-GoTime.png";
import DeleteLogoutOverlay from "./overlay/DeleteLogoutOverlay.vue";

const logoutPopupVisible = ref(false);

const logout = () => {
  // TODO: logout
  console.log("logouy");
};
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
        @click=""
        prepend-icon="mdi-view-dashboard-outline"
        title="Dashboard"
      ></v-list-item>
      <v-list-item
        @click=""
        prepend-icon="mdi-account-outline"
        title="Profile"
      ></v-list-item>
      <v-list-item
        @click=""
        prepend-icon="mdi-account-group-outline"
        title="Manage Team"
      ></v-list-item>
      <v-list-item
        @click=""
        prepend-icon="mdi-account-multiple-plus-outline"
        title="Create Team"
      ></v-list-item>
      <v-list-item
        @click=""
        prepend-icon="mdi-account-plus-outline"
        title="Add employee"
      ></v-list-item>
      <v-list-item
        @click=""
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
