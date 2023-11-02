<script setup lang="ts">
import LoginForm from '../components/auth/LoginForm.vue';
import LoginBanner from '../components/auth/LoginBanner.vue';
import { useDisplay } from 'vuetify';


const { mobile } = useDisplay()

</script>
<template>
  <v-main id="login" class="w-full h-full grid grid-cols-5 grid-flow-row-dense">
      <LoginBanner v-if="!mobile" id="login-banner" class="bg-customGrey col-span-2" />
      <LoginForm id="login-form" :class="!mobile ? 'col-span-3' : 'col-span-5'"/>
  </v-main>
</template>

<style>
#login {
  height: 100vh;
}
</style>
