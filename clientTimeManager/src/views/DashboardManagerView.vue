<script lang="ts" setup>
import {useDisplay} from 'vuetify';
import TimeGraphManger from '@/components/TimeGraphManager.vue';
import WeekSelector from "@/components/WeekSelector.vue";
import SelectOne from "@/components/form/SelectOne.vue";
import BottomNav from '@/components/BottomNav.vue';
import Sidebar from '@/components/SideBar.vue';
import TimeGraphManager from "@/components/TimeGraphManager.vue";

const { mobile } = useDisplay()

// TODO: a manager can only see the working times of his team


</script>

<template>
  <BottomNav v-if="mobile"/>
  <Sidebar v-else/>
  <v-main class="w-full h-full grid grid-cols-1">
    <div class="selector-wrapper">
      <SelectOne class="w-60 text-xs col-start-2 mt-20" label="Pick team" :itemList=listTeam hint="Pick a team"
                 v-model="queryUuid" @update:modelValue="fetchTeam()" :clearable=false />
      <WeekSelector @week-updated="updateWeek"/>
    </div>
    <TimeGraphManager v-if="workingTimesListTeam.length > 0" :key="`${start}-${end}`" :end="end" :start="start" :workingTimeList="workingTimesListTeam"/>
    <h2 v-else class="no-data">No data you need to pick a team</h2>
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
  </v-main>
</template>

<script lang="ts">
import { ref } from 'vue';
import { useUserStore } from "@/stores/user";
import {useSnackbarStore} from "@/stores/snackbar";
import {useRouter} from "vue-router";
import {errorHandling} from "@/utils/utils";
import type {TableStats} from "@/types/tableStats";
import type {TeamStats} from "@/types/teamStats";
import type {Item} from "@/types/items";

export default {
  data() {
    const user = useUserStore().getUser;

    return {
      start: new Date(),
      end: this.initOneWeekAgo(),
      workingTimesList: ref<TableStats[]>([]),
      userId: user?.id,
      snackbarStore: useSnackbarStore(),
      router: useRouter(),
      apiUrl: import.meta.env.VITE_API_URL,
      workingTimesListTeam: ref<TeamStats[]>([]),
      listTeam: ref<Item[]>([]),
      queryUuid: ref<string>(""),
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
    },
    async getTeamList() {
      const response = await fetch(`${this.apiUrl}/api/teams/manage`, {
        method: "GET",
        credentials: "include",
        headers: {
          'Content-Type': 'application/json'
        }
      });
      if (!response.ok) {
        errorHandling(response, this.snackbarStore, this.router);
        return
      }
      const data = await response.json();
      this.listTeam.values = data.data;
    },
    async fetchTeam() {
      console.log("THIS IS A FETCH" + this.queryUuid);
      const startTime = this.formatDate(this.end);
      const endTime = this.formatDate(this.start)
      console.log(`${this.apiUrl}/api/stats/team/workingtimes/average/${this.queryUuid}?start=${startTime}&end=${endTime}`);
      try {
        const response = await fetch(`${this.apiUrl}/api/stats/team/workingtimes/average/${this.queryUuid}?start=${startTime}&end=${endTime}`,
            {
              method: "GET",
              credentials: "include",
              headers: {
                'Content-Type': 'application/json'
              }
            });
        const data = await response.json();

        this.workingTimesListTeam = data.data.map(
            (w: TeamStats) => ({ // TODO: create interface to replace any
              ...w,
              day: w.day,
              start: new Date(w.start),
              end: new Date(w.end),
              average_day_hours: w.average_day_hours.toFixed(2),
              average_night_hours: w.average_night_hours ? w.average_night_hours : 0,
              average_hours: w.average_hours.toFixed(2),
              total_day_hours: w.total_day_hours.toFixed(2),
              total_night_hours: w.total_night_hours ? w.total_night_hours : 0,
              total_hours: w.total_hours.toFixed(2),
              max_hours: w.max_hours.toFixed(2),
              min_hours: w.min_hours.toFixed(2),
            })
        );

        console.log(this.workingTimesListTeam);
      } catch (error) {
        console.error(error);
      }
    }
  },
  async created() {
    await this.getTeamList();
    await this.fetchData();
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

.selector-wrapper {
  display: flex;
  flex-direction: row;
  justify-content: space-around;
  align-items: center;
  margin-top: 1rem;
  margin-bottom: 1rem;
}

.no-data {
  text-align: center;
  margin-top: 1rem;
}

</style>
