<script setup lang="ts">
import LoginForm from '../components/LoginForm.vue';
import LoginBanner from '../components/auth/LoginBanner.vue';
import { useDisplay } from 'vuetify';


const { mobile } = useDisplay()

</script>
<template>
  <main >
    <div id="Login" class="grid grid-cols-5">
      <LoginBanner v-if="!mobile" id="login-banner" class="bg-customGrey col-span-2" />
      <LoginForm id="login-form" :class="!mobile ? 'col-span-3' : 'col-span-5'"/>
    </div>
  </main>
</template>

<style>
#Login {
  height: 100vh;
}
</style>
