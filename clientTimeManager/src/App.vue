<script setup lang="ts">
import { RouterView } from 'vue-router'
import { useDisplay } from 'vuetify';
import Snackbar from './components/form/Snackbar.vue';


const { mobile } = useDisplay()
</script>

<template>
  <v-layout>

    <router-view />
    <Snackbar />
  </v-layout>
</template>

<style scoped></style>
