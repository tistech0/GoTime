<script setup lang="ts">
import BottomNav from "../components/BottomNav.vue";
import Sidebar from "../components/SideBar.vue";
import { useDisplay } from "vuetify";
import TableValidateTime from "../components/table/TableValidateTime.vue";
import Hello from "../components/Hello.vue";

const { mobile } = useDisplay();
</script>

<template>
  <BottomNav v-if="mobile" />
  <Sidebar v-else />
  <v-main class="w-full h-full grid grid-cols-5 grid-flow-row-dense">
    <Hello class="ml-20" />
    <h1 class="col-span-5">Validate your team times</h1>
    <TableValidateTime />
  </v-main>
</template>
