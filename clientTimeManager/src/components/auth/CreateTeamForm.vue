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

const { lg, mobile } = useDisplay();
const router = useRouter();
const snackbarStore = useSnackbarStore();
const apiUrl = import.meta.env.VITE_API_URL;

const createTeamFormData = ref({
  team: {
    name: "",
    manager_id: "",
  },
});
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
        label="Select a team"
        :itemList="listTeam"
        hint="Assign the employee to a team"
        v-model="createTeamFormData.team.manager_id"
        :clearable="true"
      />
      <Button
        btnColor="blue"
        buttonName="Create the manager"
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
