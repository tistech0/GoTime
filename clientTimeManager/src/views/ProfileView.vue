<script setup lang="ts">

import BottomNav from '../components/BottomNav.vue';
import SideBar from '../components/SideBar.vue';
import ProfileInfo from '../components/profile/ProfileInfo.vue';
import HeaderProfile from '../components/profile/HeaderProfile.vue';
import { useDisplay } from 'vuetify';

const { mobile } = useDisplay()
</script>

<template>
  <div>
    <BottomNav v-if="mobile" />
    <SideBar v-else />
    <v-main>
      <!-- background Desk -->
      <HeaderProfile />
      <!-- content -->
      <ProfileInfo />
    </v-main>
  </div>
</template>