<script setup lang="ts">

import { reactive, ref } from 'vue';
import BottomNav from '../components/BottomNav.vue';
import SideBar from '../components/SideBar.vue';
import TextField from '../components/TextField.vue';

let data = reactive({
  user: {
    username: "HGefbolij",
    email: 'thisIsASuperTest@test.fr',
    contractTime: 50,
    role: 'Admin',
    password: '123456',
  },
});

// put api/users/:id

import { useDisplay } from 'vuetify';
const { mobile } = useDisplay()


</script>
<template>
  <div>
    <BottomNav v-if="mobile" />
    <SideBar v-else />
    <v-main>
      <!-- background Desk -->
      <div v-if="!mobile" class="w-full h-full grid grid-row grid-cols-5 grid-flow-row-dense">
        <div class="col-span-full">
          <img src="../assets/profileBackgroung.png" alt="company" class="w-full h-auto" />
        </div>
      </div>
      <!-- SVG Mobile -->
      <div v-else class="w-full h-full grid grid-row grid-cols-5 grid-flow-row-dense">
        <div class="col-span-full">
          <svg width="100%" height="auto" viewBox="0 0 499 240" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M100.215 234.337C43.818 259.73 9.90628 193.593 0 157.35V0H499V72.935C389.57 116.156 156.611 208.945 100.215 234.337Z"
              fill="#48A9A6" fill-opacity="0.4" />
          </svg>
        </div>
      </div>


      <!-- content -->
      <div class="grid grid-cols-5">
        <div class="col-start-3">
          <!-- avatar username -->
          <div class="grid place-content-center -mt-20">
            <img src="https://api.dicebear.com/7.x/notionists/svg?seed={{ data.user.username }}" alt="profile picture"
              class="w-40 h-40 rounded-ful pb-7" />
          </div>
        </div>
        <!--  info -->
        <div :class="{ 'gap-1 mt-1': mobile }"
          class="col-span-3 col-start-2 grid-cols-3 place-content-center mt-20 md:grid flex gap-5 flex-col">
          <!-- username -->
          <div class="grid grid-cols-5 items-center">
            <v-icon class="">mdi-account-outline</v-icon>
            <div class="col-span-4">
              <TextField label="Username" inputType="username" v-model="data.user.email"
                inputValue="{{ data.user.username }}" />
            </div>
          </div>
          <!-- email -->
          <div class="grid grid-cols-5 items-center">
            <v-icon class="">mdi-email-outline</v-icon>
            <div class="col-span-4">
              <TextField label="Email" inputType="email" v-model="data.user.email" />
            </div>
          </div>
          <!-- contract time -->
          <div class=" grid grid-cols-5 items-center">
            <v-icon class="">mdi-briefcase-account-outline</v-icon>
            <div class="col-span-4">
              <TextField label="ContractTime" inputType="contractTime" v-model="data.user.contractTime" />
            </div>
          </div>
          <!-- role -->
          <div class="grid grid-cols-5 items-center">
            <v-icon>mdi-account-star-outline</v-icon>
            <div class="col-span-4">
              <TextField v-if="data.user.role == 'User' || data.user.role == 'Admin'" :disable=true label="Role"
                inputType="role" v-model="data.user.role" />
              <TextField v-else label="Role" inputType="role" v-model="data.user.role" />
            </div>
          </div>
          <div class="grid grid-cols-5 items-center">
            <v-icon>mdi-lock-outline</v-icon>
            <div class="col-span-4">
              <TextField label="Password" inputType="password" v-model="data.user.password" />
            </div>
          </div>
          <div class="grid grid-cols-5 items-center">
            <v-icon>mdi-lock-check-outline</v-icon>
            <div class="col-span-4">
              <TextField label="Confirm Password" inputType="password" v-model="data.user.password" />
            </div>
          </div>
        </div>
        <!-- Delete account button -->
        <div class="grid col-span-6">
          <v-btn :class="{ 'mt-5': mobile }" color=var(--primary-blue) class="w-60 col-start-2 text-white mt-20 mb-20 ">
            Edit account</v-btn>
        </div>
      </div>
    </v-main>
  </div>
</template>
 
<style></style>
