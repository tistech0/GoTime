<script setup lang="ts">
import BottomNav from '@/components/BottomNav.vue';
import Sidebar from '@/components/SideBar.vue';
import TimeGraph from '@/components/TimeGraphUser.vue';
import { useDisplay } from 'vuetify';


const { mobile } = useDisplay()

let min = [1, 2, 3, 2, 4, 3];
let max = [6, 7, 8, 4, 7, 6];
let series = [
    {
        name: 'Day average time',
        data: [5, 2.7, 5, 6.5, 7, 3.5],
        color: '#48A9A6',
    },
    {
        name: 'Nigth average time',
        data: [2, 4.2, 3, 1, 1.5, 2.5],
        color: '#1B2A41',
    },
]
</script>

<template>
  <BottomNav v-if="mobile" />
  <Sidebar v-else />
  <v-main class="w-full h-full grid grid-cols-5 grid-flow-row-dense">
    <TimeGraph :min="min" :max="max" :series="series" class="col-span-3" />
  </v-main>
</template>

<style scoped></style>
