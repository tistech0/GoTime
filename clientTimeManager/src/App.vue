<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import Sidebar from './components/SideBar.vue'
import Timer from './components/Timer.vue';
import { useDisplay } from 'vuetify';
import BottomNav from './components/BottomNav.vue';


const { mobile } = useDisplay()
</script>

<template>
  <v-layout>
    <BottomNav v-if="mobile" />
    <Sidebar v-else />
    <v-main class="w-full h-full">
      <Timer />
    </v-main>
  </v-layout>
</template>

<style scoped></style>
