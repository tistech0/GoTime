<script setup lang="ts">
import type { User } from "@/types/user";
import Button from "../form/Button.vue";
import { ref } from "vue";
import { useDisplay } from "vuetify";

const props = defineProps<{
  team_id: string;
  visible: boolean;
}>();

const select = ref<User[]>([]);
const listUsers = ref<User[]>([]);

defineEmits(["update:visible"]);
const apiUrl = import.meta.env.VITE_API_URL;
// fetch all users
const getUsers = async () => {
  try {
    const response = await fetch(`${apiUrl}/api/users/roles/users`, {
      method: "GET",
      credentials: "include",
      headers: {
        "Content-Type": "application/json",
      },
    });
    const data = await response.json();
    listUsers.value = data.data.map((user: any) => ({
      id: user.id,
      username: user.username,
    }));
  } catch (error) {
    console.error(error);
  }
};

getUsers();

const AddUserToTeam = async () => {
  select.value.forEach(async (u) => {
    try {
      await fetch(`${apiUrl}/api/teamUser`, {
        method: "POST",
        credentials: "include",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          team_user: {
            team_id: props.team_id,
            user_id: u,
          },
        }),
      });
    } catch (error) {
      console.error(error);
    }
  });
};

const { mobile } = useDisplay();
</script>

<template>
  <div class="fixed inset-0 flex items-center justify-center z-10">
    <div class="absolute inset-0 bg-black opacity-50"></div>
    <div
      :class="{
        'bg-white p-6 rounded-lg shadow-lg z-10': true,
        'mobile-class': mobile,
      }"
    >
      <div class="grid grid-cols-1 items-start">
        <v-icon
          class="mt-2 col-start-2 justify-self-end"
          @click="$emit('update:visible', false)"
          >mdi-window-close</v-icon
        >
        <h1 class="text-black font-semibold col-span-2 m-5" text-center>
          Add members to the team
        </h1>
        <div>
          <v-select
            v-model="select"
            :items="listUsers"
            item-title="username"
            item-value="id"
            label="Add users to the team"
            multiple
            hint="Pick users you want to add to the team"
            persistent-hint
          ></v-select>
        </div>
      </div>
      <Button
        class="m-5"
        buttonName="Validate"
        btn-color="blue"
        @click="
          () => {
            $emit('update:visible', false);
            AddUserToTeam();
          }
        "
      />
    </div>
  </div>
</template>

<style>
.mobile-class {
  margin-left: 10px;
  margin-right: 10px;
}
</style>
