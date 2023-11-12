<script setup lang="ts">
import { ref } from "vue";
import TextField from "../form/TextField.vue";
import SelectOne from "../form/SelectOne.vue";
import Button from "../form/Button.vue";
import { useDisplay } from "vuetify";
import myImage from "../../assets/Logo-GoTime.png";
import type { Item } from "../../types/items";
import { transformData, errorHandling } from "../../utils/utils";
import { useRouter } from "vue-router";
import { useSnackbarStore } from "@/stores/snackbar";
import { Role } from "../../constants/RoleEnum";
import { useUserStore } from "@/stores/user";

const { lg, mobile } = useDisplay();
const router = useRouter();
const snackbarStore = useSnackbarStore();
const apiUrl = import.meta.env.VITE_API_URL;

const userStore = useUserStore();
const user = ref(useUserStore().getUser);

const createTeamFormData = ref({
  team: {
    name: "",
    manager_id: user.value?.id,
  },
});

const handleSubmit = async () => {
  try {
    const response = await fetch(`${apiUrl}/api/teams`, {
      method: "POST",
      credentials: "include",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        team: {
          name: createTeamFormData.value.team.name,
          manager_id: createTeamFormData.value.team.manager_id,
        },
      }),
    });

    if (!response.ok) {
      errorHandling(response, snackbarStore, router, userStore.logoutUser);
      return;
    } else {
      router.push({ name: "manager" });
    }
  } catch (error) {
    console.error(error);
  }
};

// Initialize the list of teams as a list of Item
const listManager = ref<Item[]>([]);

const getAdmin = async () => {
  try {
    const response = await fetch(`${apiUrl}/api/users/roles/admins`, {
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

    const { data } = await response.json();

    listManager.value = transformData(data, "id", "username");
    listManager.value.push({
      id: user.value!.id,
      name: user.value!.username,
    });
  } catch (error) {
    console.error(error);
  }
};
getAdmin();
</script>

<template>
  <div class="grid grid-cols-1 register">
    <div v-if="mobile" class="logo-container">
      <v-img aspect-ratio="1/1" cover width="9rem" :src="myImage"> </v-img>
    </div>
    <div>
      <h1 class="text-customSecondary">CREATE A NEW TEAM</h1>
    </div>
    <form :class="!lg ? 'text-input' : ''">
      <TextField
        label="Team name"
        inputType="team name"
        v-model="createTeamFormData.team.name"
      />
      <SelectOne
        v-if="user!.role === 'General Manager'"
        label="Select a manager"
        :itemList="listManager"
        hint="Assign the employee to a team"
        v-model="createTeamFormData.team.manager_id"
        :clearable="true"
      />
      <Button
        btnColor="blue"
        buttonName="Create the team"
        type="submit"
        @click="handleSubmit()"
      ></Button>
    </form>
  </div>
</template>

<style scoped>
.welcome-message {
  font-weight: 600;
  font-size: 1rem;
  text-align: center;
}

.register {
  margin: 1rem 1rem;
}

.text-input {
  padding: 0 1rem 0 1rem;
}

.logo-container {
  margin: auto;
}
</style>
