<script setup lang="ts">
import Button from "../form/Button.vue";
import { useRouter } from "vue-router";
import { routeNames } from "@/router/index";
import { ref } from "vue";
import type { User } from "@/types/user";
import { errorHandling } from "@/utils/utils";
import { useSnackbarStore } from "@/stores/snackbar";
import { useUserStore } from "@/stores/user";
import DeleteLogoutOverlay from "../overlay/DeleteLogoutOverlay.vue";

const router = useRouter();
const snackbarStore = useSnackbarStore();
const apiUrl = import.meta.env.VITE_API_URL;
const userStore = useUserStore();

const isManagedProfile =
  router.currentRoute.value.name == routeNames.manageProfile;

const deleteAccountPopupVisible = ref(false);
const deleteAccount = () => {
  if (isManagedProfile) {
    deleteUserAccount()
  }
};

const user = ref<User | null>();

async function getUserProfile(id: string | string[]) {
  const response = await fetch(`${apiUrl}/api/users/${id}`, {
    method: "GET",
    credentials: "include",
    headers: {
      "Content-Type": "application/json",
    },
  });
  if (!response.ok) {
    errorHandling(response, snackbarStore, router, userStore.logoutUser);
    return;
  }
  const data = await response.json();
  user.value = data.data;
}

function getUserIdFromUrl(){
  return router.currentRoute.value.params.id
}

// Check which route we are in
if (isManagedProfile) {
  const userId = getUserIdFromUrl(); // Then we need to fetch the user id we want to managed from the url
  getUserProfile(userId);
} else {
  user.value = userStore.getUser;
}


async function deleteUserAccount() {
  const userId = getUserIdFromUrl();
  const response = await fetch(`${apiUrl}/api/users/${userId}`, {
    method: "DELETE",
    credentials: "include",
    headers: {
      "Content-Type": "application/json",
    },
  });
  if (!response.ok) {
    errorHandling(response, snackbarStore, router, userStore.logoutUser);
    return;
  }
  snackbarStore.showSnackbar('Account succesfully deleted', 2000, 'success');
  router.push({name : routeNames.manager})
}
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
      <v-btn
        @click="
          router.push({
            name: isManagedProfile
              ? routeNames.manageEditprofile
              : routeNames.editProfile,
          })
        "
        icon
      >
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
        <v-icon class="">mdi-briefcase-account-outline</v-icon>
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
    <div
      v-if="isManagedProfile"
      class="grid col-span-3 col-start-2 mt-10 mb-10"
    >
      <Button
        @click="deleteAccountPopupVisible = true"
        btnColor="pink"
        buttonName="Delete Account"
      />
    </div>
  </div>
</template>
