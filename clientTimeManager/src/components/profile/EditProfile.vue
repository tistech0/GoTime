<script setup lang="ts">
import { ref } from 'vue';
import TextField from '../TextField.vue';
import Button from '../form/Button.vue';
import type { Item } from "@/types/items";
import type { User } from "@/types/user";
import { Role } from '@/constants/RoleEnum'
import SelectOne from '../form/SelectOne.vue';
import { useDisplay } from 'vuetify';
import { useRouter } from 'vue-router';
import { useUserStore } from "@/stores/user";
import { useSnackbarStore } from '@/stores/snackbar';
import { routeNames } from '@/router/index';
import { transformData, errorHandling } from "@/utils/utils";


const router = useRouter();
const { mobile } = useDisplay()
const userStore = useUserStore();
const snackbarStore = useSnackbarStore();
const apiUrl = import.meta.env.VITE_API_URL;

const isManagedProfile :Boolean = router.currentRoute.value.name == routeNames.manageEditprofile;
let isSuperAdmin :Boolean = false;

let listRoles = ref<Item[]>([]);


const userForm = ref({
  user: {
        id:'',
        username: '', 
        email: '', 
        role: '',
        role_id: '',
        time_contract: 0,
        password: '',
        confirm_password: ''  
    } as User
    });

async function getUserProfile(id: string | string[]) {
    const response = await fetch(`${apiUrl}/api/users/${id}`, {
        method: "GET",
        credentials: "include",
        headers: {
            'Content-Type': 'application/json'
        }
    });
    if (!response.ok) {
        errorHandling(response, snackbarStore, router, userStore.logoutUser);
        return
    }
    const data = await response.json();
    userForm.value.user = data.data;
}

async function getRoleListManaged() {
    const response = await fetch(`${apiUrl}/api/roles`, {
        method: "GET",
        credentials: "include",
        headers: {
            'Content-Type': 'application/json'
        }
    });
    if (!response.ok) {
        errorHandling(response, snackbarStore, router, userStore.logoutUser);
        return
    }
    const data = await response.json();
    // Set the enum values for the roles
    const dataWithFormattedRole = data.data.map((role: any) => ({
        id: role.id,
        role: Role[role.role as keyof typeof Role] || role.role, // Use the enum value if available, or the original value
    }));
    listRoles.value = transformData(dataWithFormattedRole, "id", "role");
}



// Check which route we are in
if(isManagedProfile) {
  const userId = router.currentRoute.value.params.id // Then we need to fetch the user id we want to managed from the url
  getRoleListManaged();
  getUserProfile(userId)
} else {
  const user = userStore.getUser;
  if (user) {
    // Set the value from the userStore
    userForm.value.user = JSON.parse(JSON.stringify(user));
    isSuperAdmin = user.role != Role.SuperAdmin
    // Set the listRoles to only your role. Button will be disabled
    listRoles.value = [{
      id: user.role_id,
      name: user.role
    }];
  }
}

async function handleUserUpdate() {

  // Check password equality
  if(userForm.value.user.password != userForm.value.user.confirm_password) {
      snackbarStore.showSnackbar('Both password need to be the same', 2000, 'error');
      userForm.value.user.confirm_password = "";
      return
  }

  const response = await fetch(`${apiUrl}/api/users/${userForm.value.user.id}`, {
        method: "PUT",
        credentials: "include",
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(userForm.value)
    });
  if (!response.ok) {
      errorHandling(response, snackbarStore, router, userStore.logoutUser);
      return
  }
  const data = await response.json();
  // If the user it's current profile, update userStore.
  if(!isManagedProfile) {
    userStore.loginUser(data.data);
  }
  userForm.value = data.data;
  snackbarStore.showSnackbar('Profile successfully updated', 2000, 'success');
  router.push({ name: isManagedProfile ? routeNames.manageProfile : routeNames.profile })
}


</script>


<template>
  <div class="grid grid-cols-5">
    <div class="col-start-3">
      <!-- avatar username -->
      <div class="grid place-content-center -mt-20">
        <img src="https://api.dicebear.com/7.x/notionists/svg?seed={{ userForm.username }}" alt="profile picture"
             class="w-40 h-40 rounded-ful pb-7" />
      </div>
    </div>
    <!-- icon -->
    <div class="col-start-1 flex place-content-end mr-5">
      <v-btn @click="router.push({ name: isManagedProfile ? routeNames.manageProfile : routeNames.profile })" icon>
        <v-icon>mdi-arrow-left</v-icon>
      </v-btn>
    </div>
    <!--  info -->
    <div v-if="userForm.user" :class="{ 'gap-1 mt-1': mobile }"
         class="col-span-3 col-start-2 grid-cols-3 place-content-center mt-20 md:grid flex gap-5 flex-col">
      <!-- username -->
      <div class="grid grid-cols-5 items-center">
        <v-icon class="">mdi-account-outline</v-icon>
        <div class="col-span-4">
          <TextField label="Username" inputType="text" v-model="userForm.user.username"
                     :inputValue="userForm.user.username" />
        </div>
      </div>
      <!-- email -->
      <div class="grid grid-cols-5 items-center">
        <v-icon class="">mdi-email-outline</v-icon>
        <div class="col-span-4">
          <TextField label="Email" inputType="email" v-model="userForm.user.email" :inputValue="userForm.user.email" :disable="(!isManagedProfile && isSuperAdmin) ? true : false"/>
        </div>
      </div>
      <!-- contract time -->
      <div class=" grid grid-cols-5 items-center">
        <v-icon class="">mdi-briefcase-account-outline</v-icon>
        <div class="col-span-4">
          <TextField label="ContractTime" inputType="number" v-model="userForm.user.time_contract" :inputValue="userForm.user.time_contract" :disable="(!isManagedProfile && isSuperAdmin) ? true : false"/>
        </div>
      </div>
      <!-- role -->
      <div class="grid grid-cols-5 items-center">
        <v-icon>mdi-account-star-outline</v-icon>
        <div class="col-span-4">
          <SelectOne label="Select a role" :itemList=listRoles hint="Assign a role to the user"
                     v-model="userForm.user.role_id" :disable="(!isManagedProfile && isSuperAdmin) ? true : false"
/>
        </div>
      </div>
      <div class="grid grid-cols-5 items-center">
        <v-icon>mdi-lock-outline</v-icon>
        <div class="col-span-4">
          <TextField label="Password" inputType="password" v-model="userForm.user.password" :inputValue="userForm.user.password"/>
        </div>
      </div>
      <div class="grid grid-cols-5 items-center">
        <v-icon>mdi-lock-check-outline</v-icon>
        <div class="col-span-4">
          <TextField label="Confirm Password" inputType="password" v-model="userForm.user.confirm_password" :inputValue="userForm.user.confirm_password"/>
        </div>
      </div>
    </div>
    <!-- Delete account button -->
    <div class="grid col-span-3 col-start-2 mt-10 mb-10">
      <Button btnColor="blue" buttonName="Update" @click=handleUserUpdate()></Button>
    </div>
  </div>
</template>