<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import Sidebar from './components/SideBar.vue'
import Timer from './components/Timer.vue';
import { useDisplay } from 'vuetify';
import BottomNav from './components/BottomNav.vue';
import DashboardView from './views/DashboardView.vue';


const { mobile } = useDisplay()
</script>

<template>
  <v-layout>
    <DashboardView />
  </v-layout>
</template>

<style scoped></style>
