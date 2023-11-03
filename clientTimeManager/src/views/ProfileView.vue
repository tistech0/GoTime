<script setup lang="ts">

import BottomNav from '../components/BottomNav.vue';
import SideBar from '../components/SideBar.vue';


import { useDisplay } from 'vuetify';

const { mobile } = useDisplay()

</script>
<template>
  <div class="about">
    <BottomNav v-if="mobile" />
    <SideBar v-else />
    <v-main class="w-full h-full grid grid-cols-5 grid-flow-row-dense">
      <div class="col-span-5">
        <img src="../assets/profileBackgroung.png" alt="company" class="w-full" />
      </div>
      <div class="col-span-3">
        <div class="grid grid-flow-row grid-cols-3">
          <div>
            <div>
              <v-icon>mdi-email-outline</v-icon>
            </div>
          </div>
          <div>
            <div>
              <v-icon>mdi-briefcase-account-outline</v-icon>
            </div>
          </div>
          <div>
            <div>
              <v-icon>mdi-account-star-outline</v-icon>
            </div>
          </div>
        </div>
        <div>
          <v-btn color=var(--secondary-pink) class="w-60 mt-8 text-white">
            Delete account</v-btn>
        </div>
      </div>
    </v-main>
  </div>
</template>

<style></style>
