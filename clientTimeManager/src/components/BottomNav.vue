<script lang="ts" setup>
import { useDisplay } from "vuetify";
import { useRouter } from "vue-router";
const router = useRouter();
const { smAndUp } = useDisplay();
</script>

<template>
  <v-bottom-navigation>
    <v-btn @click="router.push({ name: 'home' })" value="favorites">
      <v-icon> mdi-view-dashboard-outline</v-icon>

      <span v-if="smAndUp">Dashboard</span>
    </v-btn>
    <v-btn @click="router.push({ name: 'manager' })" value="favorites">
      <v-icon> mdi-account-group-outline</v-icon>

      <span v-if="smAndUp">Manage Team</span>
    </v-btn>
    <v-btn @click="router.push({ name: 'register' })" value="Add Employee">
      <v-icon>mdi-account-plus-outline</v-icon>

      <span v-if="smAndUp">Add employee</span>
    </v-btn>
    <v-btn @click="router.push({ name: 'validate-time' })" value="Approve Time">
      <v-icon>mdi-account-check-outline</v-icon>
      <span v-if="smAndUp">Approve Time</span>
    </v-btn>
    <v-btn @click="router.push({ name: 'profile' })">
      <v-icon>mdi-account-outline</v-icon>
      <span v-if="smAndUp">Profile</span>
    </v-btn>
  </v-bottom-navigation>
</template>
