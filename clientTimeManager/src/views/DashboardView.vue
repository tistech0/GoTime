<script lang="ts" setup>
import {useDisplay} from 'vuetify';
import WeekSelector from "@/components/WeekSelector.vue";
const {mobile} = useDisplay()
</script>

<template>
  <BottomNav v-if="mobile"/>
  <Sidebar v-else/>
  <v-main class="w-full h-full grid grid-cols-1 md:grid-cols-5 grid-flow-row-dense">
    <Timer class="md:col-span-2"/>
    <div class="data-wrapper md:col-span-3">
      <WeekSelector @week-updated="updateWeek"/>
      <TimeGraph :key="`${start}-${end}`" :end="end" :start="start" :workingTimeList="workingTimesList"/>
      <hr v-if="workingTimesList.length > 0">
      <v-table class="" fixed-header>
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
            <td>{{ formatHourMin(item.valueDay) }}</td>
            <td>{{ formatHourMin(item.valueNight) }}</td>
            <td>
              <v-icon class="mr-2">
                mdi-clock-edit-outline
              </v-icon>
              <v-icon class="mr-2">
                mdi-delete-alert-outline
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
import { ref } from 'vue';
import BottomNav from '../components/BottomNav.vue';
import Sidebar from '../components/SideBar.vue';
import Timer from '../components/Timer.vue';
import TimeGraph from '../components/TimeGraphUser.vue';
import type { TableStats } from '../types/tableStats';
import { useUserStore } from "@/stores/user";

export default {
  components: {Timer, BottomNav, Sidebar, TimeGraph},
  data() {
    const user = useUserStore().getUser;

    return {
      start: new Date(),
      end: this.initOneWeekAgo(),
      workingTimesList: ref<TableStats[]>([]),
      userId: user.id
    };
  },
  methods: {
    initOneWeekAgo() {
      let week = new Date();
      week.setDate(week.getDate() - 6);
      return week;
    },
    async updateWeek(currentDate: Date) {
      this.start = new Date(currentDate);
      this.end = new Date(currentDate);
      this.end.setDate(this.end.getDate() - 6);
      await this.fetchData();
    },
    async fetchData() {
      this.workingTimesList = [];
      try {
        const apiUrl = import.meta.env.VITE_API_URL;
        const startTime = this.formatDate(this.end);
        const endTime = this.formatDate(this.start)
        const response = await fetch(`${apiUrl}/api/workingtimes/${this.userId}?start=${startTime}&end=${endTime}`,
            {
              method: "GET",
              credentials: "include",
              headers: {
                'Content-Type': 'application/json'
              }
            });
        const data = await response.json();
        const validateWorkingTimes = data.data.filter((item: { status: string }) => item.status === 'validated');
        this.workingTimesList = validateWorkingTimes.map(
            (w: any) => ({ // TODO: create interface to replace any
              start: new Date(w.start),
              end: new Date(w.end),
              valueDay: parseFloat(w.valueDay).toFixed(2),
              valueNight: w.valueNight ? parseFloat(w.valueNight) : 0,
            })
        );
      } catch (error) {
        console.error(error);
      }
    },
    formatDate(date: Date) {
      const year = date.getFullYear();
      const month = ('0' + (date.getMonth() + 1)).slice(-2);
      const day = ('0' + date.getDate()).slice(-2);
      const hours = ('0' + date.getHours()).slice(-2);
      const minutes = ('0' + date.getMinutes()).slice(-2);
      const seconds = ('0' + date.getSeconds()).slice(-2);
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    },
    formatHourMin(value: number) {
      const hours = Math.floor(value);
      const minutes = Math.round((value - hours) * 60);
      return `${hours}h ${minutes}min`;
    }
  },
  mounted() {
    this.fetchData();
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

.data-wrapper {
  width: 80%;
  margin: 50px auto;
}

</style>
