<script setup lang="ts">
import HeaderProfile from '../components/profile/HeaderProfile.vue';
import BottomNav from '../components/BottomNav.vue';
import SideBar from '../components/SideBar.vue';
import EditProfile from '../components/profile/EditProfile.vue';
import { useDisplay } from 'vuetify';
const { mobile } = useDisplay()

// put api/users/:id

</script>

<template>
  <div>
    <BottomNav v-if="mobile" />
    <SideBar v-else />
    <v-main>
      <!-- arrow icon -->

      <!-- background Desk -->
      <HeaderProfile />
      <!-- content -->
      <EditProfile />
    </v-main>
  </div>
</template>
