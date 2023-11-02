<script setup lang="ts">

import BottomNav from '../components/BottomNav.vue';
import SideBar from '../components/SideBar.vue';
import RegisterForm from '../components/auth/RegisterForm.vue';
import { useDisplay } from 'vuetify';


const { mobile } = useDisplay()

</script>
<template>
  <div class="about">
    <BottomNav v-if="mobile" />
    <SideBar v-else />
    <v-main class="w-full h-full grid grid-cols-5 grid-flow-row-dense">
      <div v-if="!mobile" class="col-span-5">
        <img src="../assets/profileBackgroung.png" alt="company" class="w-full" />
      </div>
    <RegisterForm id="register-form" :class="!mobile ? 'col-span-3' : 'col-span-5'"/>
    </v-main>
  </div>
</template>

<style>
#register-form {
}

</style>
