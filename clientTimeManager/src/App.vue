<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import { useDisplay } from 'vuetify';


const { mobile } = useDisplay()
</script>

<template>
  <v-layout>
    <router-view />
  </v-layout>
</template>

<style scoped></style>
