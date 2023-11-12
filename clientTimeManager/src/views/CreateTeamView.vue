<script setup lang="ts">
import BottomNav from "../components/BottomNav.vue";
import SideBar from "../components/SideBar.vue";
import CreateTeamForm from "../components/auth/CreateTeamForm.vue";
import { useDisplay } from "vuetify";

const { mobile } = useDisplay();
</script>
<template>
  <BottomNav v-if="mobile" />
  <SideBar v-else />
  <v-main
    class="w-full h-full grid grid-cols-5 grid-flow-row-dense register-view"
  >
    <div v-if="!mobile" class="col-span-5">
      <img src="../assets/profileBackgroung.png" alt="company" class="w-full" />
    </div>
    <CreateTeamForm
      id="create-team-form"
      :class="!mobile ? 'col-span-3 col-start-2' : 'col-span-5'"
    />
  </v-main>
</template>

<style>
.register-view {
  margin-bottom: 2rem;
}
</style>
