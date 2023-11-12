<script lang="ts" setup>
import { useDisplay } from "vuetify";
import WeekSelector from "@/components/WeekSelector.vue";
import type { WorkingTime } from "@/types/workingTime";

const { mobile } = useDisplay();
const deleteTimePopupVisible = ref(false);
const editTimePopupVisible = ref(false);
let workingtimes_id = ref<string>();
let selectedItem = ref<WorkingTime>();
</script>

<template>
  <BottomNav v-if="mobile" />
  <Sidebar v-else />
  <DeleteLogoutOverlay
    ref="deleteTimePopup"
    title="Delete your time"
    description="Are you sure you want to delete this time?"
    @action="
      async () => {
        await deleteWorkingTime(workingtimes_id!);
        fetchDataGraph();
        fetchDataArray();
      }
    "
    v-model:visible="deleteTimePopupVisible"
    v-if="deleteTimePopupVisible"
  />
  <NewEditTimeOverlay
    ref="editTimePopup"
    title="Edit your time"
    v-model:visible="editTimePopupVisible"
    v-model:item="selectedItem"
    v-if="editTimePopupVisible"
    @action="
      async () => {
        await editWorkingTime(workingtimes_id!, selectedItem!);
        fetchDataGraph();
        fetchDataArray();
      }
    "
  />
  <v-main
    class="w-full h-full grid grid-cols-1 md:grid-cols-5 grid-flow-row-dense"
  >
    <Timer
      class="md:col-span-2"
      @clock-stoped="actualiseData"
      @edit-time="(item: WorkingTime) => {
        workingtimes_id = item.id;
        selectedItem = item;
        editTimePopupVisible = true;
      }"
      :username="userUsername"
    />
    <div class="data-wrapper md:col-span-3">
      <h1 class="text-center" v-if="$route.params.username">
        Working times of {{ userUsername }}
      </h1>
      <WeekSelector @week-updated="updateWeek" />
      <TimeGraph
        :end="end"
        :start="start"
        :workingTimeList="workingTimesListGraph"
        :key="keyNumber"
      />

      <hr v-if="workingTimesListArray.length > 0" />
      <v-table class="" fixed-header :key="keyNumber">
        <thead class="drop-shadow-md">
        <tr>
          <th class="text-left">Start</th>
          <th class="text-left">End</th>
          <th class="text-left">Day</th>
          <th class="text-left">Night</th>
          <th class="text-left">Operation</th>
        </tr>
        </thead>
        <tbody>
        <template v-if="workingTimesListArray.length === 0">
            <tr>
              <td class="text-center" colspan="7">No data available</td>
            </tr>
        </template>
        <template v-else>
          <tr v-for="item in workingTimesListArray" :key="item.id">
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
              <v-icon
                  @click="
                    () => {
                      workingtimes_id = item.id;
                      selectedItem = item;
                      editTimePopupVisible = true;
                    }
                  "
                  class="mr-2"
              >
                mdi-clock-edit-outline
              </v-icon>
              <v-icon
                  @click="
                    () => {
                      workingtimes_id = item.id;
                      deleteTimePopupVisible = true;
                    }
                  "
                  class="mr-2"
              >
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
import type { UserStat } from "@/types/userStat";
import type { TableStats } from "@/types/tableStats";
import DeleteLogoutOverlay from "../components/overlay/DeleteLogoutOverlay.vue";
import NewEditTimeOverlay from "../components/overlay/NewEditTimeOverlay.vue";
import { useUserStore } from "@/stores/user";
import { reactive } from "vue";
import type { Clock } from "@/types/clock";

export default {
  components: { Timer, BottomNav, Sidebar, TimeGraph, DeleteLogoutOverlay },
  data() {
    const user = useUserStore().getUser;

    return {
      start: new Date(),
      end: this.initOneWeekAgo(),
      workingTimesListGraph: ref<UserStat[]>([]),
      workingTimesListArray: ref<TableStats[]>([]),
      userId: this.setUserId(user),
      userUsername: this.setUserUsername(user),
      keyNumber: 0,
    };
  },
  methods: {
    initOneWeekAgo() {
      let week = new Date();
      week.setDate(week.getDate() - 6);
      return week;
    },
    setUserId(user: any) {
      const routeId = this.$route.params.id;
      return routeId ? routeId : user.id;
    },
    setUserUsername(user: any) {
      const routeUsername = this.$route.params.username;
      return routeUsername ? routeUsername : user.username;
    },
    async updateWeek(currentDate: Date) {
      this.start = new Date(currentDate);
      this.end = new Date(currentDate);
      this.end.setDate(this.end.getDate() - 6);
      await this.fetchDataGraph();
      await this.fetchDataArray();
      this.keyNumber++;
    },
    async fetchDataGraph() {
      try {
        const apiUrl = import.meta.env.VITE_API_URL;
        const startTime = this.formatDate(this.end);
        const endTime = this.formatDate(this.start)
        const response = await fetch(`${apiUrl}/api/stats/user/workingtimes/${this.userId}?start=${startTime}&end=${endTime}`,
            {
              method: "GET",
              credentials: "include",
              headers: {
                'Content-Type': 'application/json'
              }
            });
        const data = await response.json();
        console.log(data);
        this.workingTimesListGraph = data.data.map(
            (w: UserStat) => ({
              day: w.day,
              total_day_hours: w.total_day_hours,
              total_hours: w.total_hours,
              total_night_hours: w.total_night_hours,
            })
        );
      } catch (error) {
        console.error(error);
      }
    },
    async fetchDataArray() {
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
        const validateWorkingTimes = data.data.filter(
            (item: { status: string }) => item.status === "validated"
        );
        this.workingTimesListArray = validateWorkingTimes.map((w: any) => ({
          // TODO: create interface to replace any
          ...w,
          start: new Date(w.start),
          end: new Date(w.end),
          valueDay: parseFloat(w.valueDay).toFixed(2),
          valueNight: w.valueNight ? parseFloat(w.valueNight) : 0,
        }));
      } catch (error) {
        console.error(error);
      }
    },
    async deleteWorkingTime(workingtimes_id: string) {
      try {
        const apiUrl = import.meta.env.VITE_API_URL;
        const response = await fetch(
          `${apiUrl}/api/workingtimes/${workingtimes_id}`,
          {
            method: "DELETE",
            credentials: "include",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );
        const data = await response;
      } catch (error) {
        console.error(error);
      }
    },
    async editWorkingTime(workingtimes_id: string, item: WorkingTime) {
      try {
        const apiUrl = import.meta.env.VITE_API_URL;
        const response = await fetch(
          `${apiUrl}/api/workingtimes/${workingtimes_id}`,
          {>>>>>>> main
            method: "PUT",
            credentials: "include",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              working_times: {
                start: this.formatDate(item.start),
                end: this.formatDate(item.end),
              },
            }),
          }
        );
        const data = await response;
      } catch (error) {
        console.error(error);
      }
    },

    formatDate(date: Date) {
      const year = date.getFullYear();
      const month = ("0" + (date.getMonth() + 1)).slice(-2);
      const day = ("0" + date.getDate()).slice(-2);
      const hours = ("0" + date.getHours()).slice(-2);
      const minutes = ("0" + date.getMinutes()).slice(-2);
      const seconds = ("0" + date.getSeconds()).slice(-2);
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    },
    formatHourMin(value: number) {
      const hours = Math.floor(value);
      const minutes = Math.round((value - hours) * 60);
      return `${hours}h ${minutes}min`;
    },
    actualiseData() {
      this.keyNumber++;
      this.fetchDataArray();
      this.fetchDataGraph();
    },
  },
  mounted() {
    this.fetchDataArray();
    this.fetchDataGraph();
  },
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
  width: 95%;
  margin: 50px auto;
}
</style>
