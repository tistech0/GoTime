<script setup lang="ts">
import Button from "../form/Button.vue";
import { useRouter } from "vue-router";
import DeleteLogoutOverlay from "../overlay/DeleteLogoutOverlay.vue";
const router = useRouter();
const deleteAccountPopupVisible = ref(false);
const deleteAccount = () => {
  // TODO: delete account
  console.log("Account deleted");
};
</script>

<template>
  <DeleteLogoutOverlay
    ref="deleteAccountPopup"
    title="Delete account"
    description="Are you sure you want to delete this account?"
    @action="deleteAccount"
    v-model:visible="deleteAccountPopupVisible"
    v-if="deleteAccountPopupVisible"
  />
  <div class="grid grid-cols-5">
    <div class="col-start-3">
      <!-- avatar username -->
      <div class="grid place-content-center -mt-20">
        <img
          src="https://api.dicebear.com/7.x/notionists/svg?seed={{ user.username }}"
          alt="profile picture"
          class="w-40 h-40 rounded-ful pb-7"
        />
        <p class="text-center font-semibold">{{ user?.username }}</p>
      </div>
    </div>
    <!-- edit button -->
    <div class="col-start-5 flex place-content-end mr-5">
      <v-btn @click="router.push({ name: 'editprofile' })" icon>
        <v-icon>mdi-square-edit-outline</v-icon>
      </v-btn>
    </div>
    <!--  info -->
    <div
      class="col-span-3 col-start-2 grid-cols-3 place-content-center mt-20 md:grid flex gap-5 flex-col"
    >
      <!-- email -->
      <div class="grid grid-cols-5 items-center">
        <v-icon class="">mdi-email</v-icon>
        <div>
          <p class="font-semibold">Email</p>
          <p>{{ user?.email }}</p>
        </div>
      </div>
      <!-- contract time -->
      <div class="grid grid-cols-5 items-center">
        <v-icon class="">mdi-briefcase-alogoutccount-outline</v-icon>
        <div>
          <p class="font-semibold">Contract</p>
          <p>{{ user?.time_contract }}</p>
        </div>
      </div>
      <!-- role -->
      <div class="grid grid-cols-5 items-center">
        <v-icon>mdi-account-star-outline</v-icon>
        <div>
          <p class="font-semibold">Role</p>
          <p>{{ user?.role }}</p>
        </div>
      </div>
    </div>
    <!-- Delete account button -->
    <div class="grid col-span-3 col-start-2 mt-10 mb-10">
      <Button
        btnColor="pink"
        buttonName="Delete Account"
        @click="deleteAccountPopupVisible = true"
      />
    </div>
  </div>
</template>

<script lang="ts">
import { useUserStore } from "@/stores/user";
import { ref } from "vue";

export default {
  data() {
    const user = useUserStore().getUser;

    return {
      user: user,
    };
  },
};
</script>
