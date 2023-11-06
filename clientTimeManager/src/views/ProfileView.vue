<script setup lang="ts">

import { reactive, ref } from 'vue';
import BottomNav from '../components/BottomNav.vue';
import SideBar from '../components/SideBar.vue';

let data = reactive({
  user: {
    username: "HGefbolij",
    email: 'thisIsASuperTest@test.fr',
    contractTime: 50,
    role: 'user',
  },
});

// fetch data from API
// get api/users/:id (id = me)



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
            <p class="text-center font-semibold">{{ data.user.username }}</p>
          </div>
        </div>
        <!-- edit button -->
        <div class="col-start-5 flex place-content-end mr-5">
          <v-btn @click="$router.push('editprofile')" icon>
            <v-icon>mdi-square-edit-outline</v-icon>
          </v-btn>
        </div>
        <!--  info -->
        <div class="col-span-3 col-start-2 grid-cols-3 place-content-center mt-20 md:grid flex gap-5 flex-col">
          <!-- email -->
          <div class="grid grid-cols-5 items-center">
            <v-icon class="">mdi-email</v-icon>
            <div>
              <p class="font-semibold">Email</p>
              <p>{{ data.user.email }}</p>
            </div>
          </div>
          <!-- contract time -->
          <div class="grid grid-cols-5 items-center">
            <v-icon class="">mdi-briefcase-account-outline</v-icon>
            <div>
              <p class="font-semibold">Contract</p>
              <p>{{ data.user.contractTime }}</p>
            </div>
          </div>
          <!-- role -->
          <div class="grid grid-cols-5 items-center">
            <v-icon>mdi-account-star-outline</v-icon>
            <div>
              <p class="font-semibold">Role</p>
              <p>{{ data.user.role }}</p>
            </div>
          </div>
        </div>
        <!-- Delete account button -->
        <div class="grid col-span-5">
          <v-btn color=var(--secondary-pink) class="w-60 col-start-2 text-white mt-20 mb-20 ">
            Delete account</v-btn>
        </div>
      </div>

    </v-main>
  </div>
</template>
 
<style></style>
