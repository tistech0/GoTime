<script setup lang="ts">
import Timer from '../components/Timer.vue';
import BottomNav from '@/components/BottomNav.vue';
import Sidebar from '@/components/SideBar.vue';
import ManagerGraph from '@/components/ManagerGraph.vue';
import { useDisplay } from 'vuetify';


const { mobile } = useDisplay()

let data = [
        {
            "id": 1,
            "start": "2023-10-25T20:48:13",
            "end": "2023-10-25T20:48:37",
            "valueDay": 3,
            "valueNight": 0,
        },
        {
            "id": 2,
            "start": "2023-11-25T09:23:45",
            "end": "2023-11-25T18:30:31",
            "valueDay": 4,
            "valueNight": 3,
        },
        {
            "id": 3,
            "start": "2023-12-25T10:21:25",
            "end": "2023-12-25T17:49:56",
            "valueDay": 3,
            "valueNight": 8,
        }
    ]

let min = [1, 2, 3, 2, 4, 3];
let max = [6, 7, 8, 4, 7, 6];
let series = createSeries(data);

function createSeries(data: any) {
  let series = [];
  let day: any = [];
  let night: any = [];

  data.forEach((element: any) => {
    day.push(element.valueDay);
    night.push(element.valueNight);
  });

  series.push({
    name: "Day average time",
    data: day,
    color: "#48A9A6",
  });

  series.push({
    name: "Nigth average time",
    data: night,
    color: "#1B2A41",
  });

  return series;
}

</script>

<template>
  <BottomNav v-if="mobile" />
  <Sidebar v-else />
  <v-main class="w-full h-full grid grid-cols-5 grid-flow-row-dense">
    <Timer class=" col-span-2" />
    <ManagerGraph :min="min" :max="max" :series="series" class="col-span-3" />
  </v-main>
</template>

<style scoped></style>
