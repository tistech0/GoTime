<script lang="ts" setup>
import {useDisplay} from 'vuetify';
import WeekSelector from "@/components/WeekSelector.vue";
import type { TableStats } from '../types/tableStats';
import { ref } from "vue";

const {mobile} = useDisplay()

let workingTimesList = ref<TableStats[]>([]);
const fetchData = async () => {
  try {
    const apiUrl = import.meta.env.VITE_API_URL;
    const response = await fetch(`${apiUrl}/api/workingtimes/1?start=2023-10-25 20:48:13&end=2023-12-25 17:49:56`,
        {
          method: "GET",
          credentials: "include",
          headers: {
            'Content-Type': 'application/json'
          }
        });
    const data = await response.json();
    const waitingWorkingTimes = data.data.filter((item: { status: string }) => item.status === 'waiting');
    workingTimesList.value = waitingWorkingTimes.map(
        (w: any) => ({ // TODO: create interface to replace any
          start: new Date(w.start),
          end: new Date(w.end),
          valueDay: parseInt(w.valueDay),
          valueNight: parseInt(w.valueNight),
        })
    );
    console.log(workingTimesList.value);
  } catch (error) {
    console.error(error);
  }
};
fetchData();
</script>

<template>
  <BottomNav v-if="mobile"/>
  <Sidebar v-else/>
  <v-main class="w-full h-full grid grid-cols-1 md:grid-cols-5 grid-flow-row-dense">
    <Timer class="md:col-span-2"/>
    <div class="data-wrapper md:col-span-3">
      <WeekSelector @week-updated="updateWeek"/>
      <TimeGraph :key="`${start}-${end}`" :end="end" :start="start"/>
      <hr>
      <v-table class="col-span-3 col-start-2 mt-10" fixed-header height="500px">
        <thead class="drop-shadow-md">
        <tr>
          <th class="text-left">
            Start
          </th>
          <th class="text-left">
            End
          </th>
          <th class="text-left">
            Day
          </th>
          <th class="text-left">
            Night
          </th>
          <th class="text-left">
            Operation
          </th>
        </tr>
        </thead>
        <tbody>
        <template v-if="workingTimesList.length === 0">
          <tr>
            <td class="text-center" colspan="7">
              No data available
            </td>
          </tr>
        </template>
        <template v-else>
          <tr v-for="item in workingTimesList" :key="item.id">
            <td>
              {{
                item.start.toLocaleString("en", {
                  month: "short",
                  day: "numeric",
                  hour: "numeric",
                  minute: "numeric",
                  year: "numeric",
                })
              }}
            </td>
            <td>
              {{
                item.end.toLocaleString("en", {
                  month: "short",
                  day: "numeric",
                  hour: "numeric",
                  minute: "numeric",
                  year: "numeric",
                })
              }}
            </td>
            <td>{{ (Math.round(item.valueDay * 100) / 100).toFixed(2) }} h</td>
            <td>{{ (Math.round(item.valueNight * 100) / 100).toFixed(2) }} h</td>
            <td>
              <!-- sum valueDay and valueNight -->
              {{
                (Math.round((item.valueDay + item.valueNight) * 100) / 100).toFixed(2)

              }}
            </td>
            <td>
              <v-icon class="mr-2">
                mdi-check
              </v-icon>
              <v-icon class="mr-2">
                mdi-close
              </v-icon>
            </td>
          </tr>
        </template>
        </tbody>
      </v-table>
    </div>
  </v-main>
</template>

<script lang="ts">
import BottomNav from '../components/BottomNav.vue';
import Sidebar from '../components/SideBar.vue';
import Timer from '../components/Timer.vue';
import TimeGraph from '../components/TimeGraph.vue';

export default {
  components: {Timer, BottomNav, Sidebar, TimeGraph},
  data() {
    return {
      start: new Date(),
      end: this.initOneWeekAgo(),
    };
  },
  methods: {
    initOneWeekAgo() {
      let week = new Date();
      week.setDate(week.getDate() - 6);
      return week;
    },
    updateWeek(currentDate: Date) {
      this.start = new Date(currentDate);
      this.end = new Date(currentDate);
      this.end.setDate(this.end.getDate() - 6);
    }
  }
};

</script>

<style scoped>

hr {
  border: 0;
  height: 1px;
  background: #333;
  margin: 1rem 0;
  width: 70%;
  margin-left: auto;
  margin-right: auto;
}

</style>
