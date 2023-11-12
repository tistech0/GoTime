<template>
  <BottomNav v-if="mobile" />
  <Sidebar v-else />
  <DeleteLogoutOverlay
    ref="deleteTeamPopup"
    title="Delete the team"
    description="Are you sure you want to delete this team?"
    @action="
      async () => {
        await deleteTeam(queryUuid);
        fetchData();
      }
    "
    v-model:visible="deleteTeamPopupVisible"
    v-if="deleteTeamPopupVisible"
  />
  <v-main class="page-wrapper">
    <div class="selector-wrapper">
      <SelectOne
        class="w-60 text-xs col-start-2 mt-20"
        label="Pick team"
        :itemList="listTeam"
        hint="Pick a team"
        v-model="queryUuid"
        @update:modelValue="updateAll()"
        :clearable="false"
      />
      <AddMemberOverlay
        :team_id="queryUuid"
        v-model:visible="addNewMemberPopupVisible"
        v-if="addNewMemberPopupVisible"
      />
      <WeekSelector @week-updated="updateWeek" />
    </div>
    <TimeGraphManager
      v-if="workingTimesListTeam.length > 0"
      :key="`${start}-${end}`"
      :end="end"
      :start="start"
      :workingTimeList="workingTimesListTeam"
    />
    <h2 v-else class="no-data">No data you need to pick a team</h2>
    <hr v-if="workingTimesList.length > 0" />
    <div class="button-manager-wrapper">
      <Button
        @on-click="router.push({ name: routeNames.createTeam })"
        button-name="Add a new Team"
        btn-color="blue"
        style="width: 100%"
      />
      <Button
        @click="deleteTeamPopupVisible = true"
        button-name="Remove Team"
        btn-color="pink"
        style="width: 100%"
      />
      <Button
        @click="addNewMemberPopupVisible = true"
        button-name="Add a new Member"
        btn-color="blue"
        style="width: 100%"
      />
    </div>
    <v-table class="" fixed-header>
      <thead class="drop-shadow-md">
        <tr>
          <th class="text-left">Time to validate</th>
          <th class="text-left">Name</th>
          <th class="text-left">Day</th>
          <th class="text-left">Night</th>
          <th class="text-left">total</th>
          <th class="text-left">Remove User</th>
        </tr>
      </thead>
      <tbody>
        <template v-if="workingTimesList.length === 0">
          <tr>
            <td class="text-center" colspan="7">No data available</td>
          </tr>
        </template>
        <template v-else>
          <tr v-for="item in workingTimesList" :key="item.id">
            <td>
              <v-icon class="mr-2" v-if="!item.needValidation">
                mdi-check-circle-outline
              </v-icon>
              <v-icon
                class="mr-2"
                v-else
                @click="
                  router.push({
                    name: routeNames.validateTimeUser,
                    params: { id: queryUuid },
                  })
                "
              >
                mdi-alert-box-outline
              </v-icon>
            </td>
            <td
              @click="
                router.push({
                  name: routeNames.userLook,
                  params: { id: item.user.id, username: item.user.username },
                })
              "
            >
              {{ item.user.username }}
            </td>
            <td>{{ formatHourMin(item.valueDay) }}</td>
            <td>{{ formatHourMin(item.valueNight) }}</td>
            <td>{{ formatHourMin(item.valueDay + item.valueNight) }}</td>
            <td>
              <v-icon class="mr-2"> mdi-account-remove-outline </v-icon>
            </td>
          </tr>
        </template>
      </tbody>
    </v-table>
  </v-main>
</template>

<script setup lang="ts">
const { mobile } = useDisplay();
</script>

<script lang="ts">
import { ref } from "vue";
import { useUserStore } from "@/stores/user";
import { useSnackbarStore } from "@/stores/snackbar";
import { useRouter } from "vue-router";
import { errorHandling } from "@/utils/utils";
import type { TableTeamStats } from "@/types/tableTeamStats";
import type { TeamStats } from "@/types/teamStats";
import type { Item } from "@/types/items";
import { useDisplay } from "vuetify";
import TimeGraphManger from "@/components/TimeGraphManager.vue";
import WeekSelector from "@/components/WeekSelector.vue";
import TimeGraphManager from "@/components/TimeGraphManager.vue";
import SelectOne from "@/components/form/SelectOne.vue";
import BottomNav from "@/components/BottomNav.vue";
import Sidebar from "@/components/SideBar.vue";
import { routeNames } from "@/router";
import DeleteLogoutOverlay from "../components/overlay/DeleteLogoutOverlay.vue";
import Button from "@/components/form/Button.vue";
import AddMemberOverlay from "../components/overlay/AddMemberOverlay.vue";

const deleteTeamPopupVisible = ref(false);
const addNewMemberPopupVisible = ref(false);
export default {
  computed: {
    routeNames() {
      return routeNames;
    },
  },
  components: {
    Button,
    TimeGraphManger,
    WeekSelector,
    SelectOne,
    BottomNav,
    Sidebar,
    TimeGraphManager,
  },
  data() {
    const userStore = useUserStore();
    const user = userStore.getUser;

    return {
      start: new Date(),
      end: this.initOneWeekAgo(),
      workingTimesList: ref<TableTeamStats[]>([]),
      userId: user?.id,
      snackbarStore: useSnackbarStore(),
      userStore: userStore,
      router: useRouter(),
      apiUrl: import.meta.env.VITE_API_URL,
      workingTimesListTeam: ref<TeamStats[]>([]),
      listTeam: [] as Item[],
      queryUuid: ref<string>(""),
      mobile: useDisplay().smAndDown,
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
    async deleteTeam(uuid: string) {
      try {
        const response = await fetch(`${this.apiUrl}/api/teams/${uuid}`, {
          method: "DELETE",
          credentials: "include",
          headers: {
            "Content-Type": "application/json",
          },
        });
        if (!response.ok) {
          errorHandling(
            response,
            this.snackbarStore,
            this.router,
            this.userStore.logoutUser
          );
          return;
        }
      } catch (error) {
        console.error(error);
      }
    },
    async fetchData() {
      let workingTimesListFlat: TableTeamStats[];
      try {
        const apiUrl = import.meta.env.VITE_API_URL;
        const startTime = this.formatDate(this.end);
        const endTime = this.formatDate(this.start);

        const response = await fetch(
          `${apiUrl}/api/stats/team/workingtimes/all/${this.queryUuid}?start=${startTime}&end=${endTime}`,
          {
            method: "GET",
            credentials: "include",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );
        const data = await response.json();

        const WorkingTimes = data.data.filter(
          (item: { status: string }) =>
            item.status === "validated" || item.status === "waiting"
        );
        workingTimesListFlat = WorkingTimes.map((w: any) => ({
          ...w,
          id: w.id,
          start: new Date(w.start),
          status: w.status,
          end: new Date(w.end),
          valueDay: parseFloat(w.valueDay).toFixed(2),
          valueNight: parseFloat(w.valueNight).toFixed(2),
          user: w.user,
        }));
        this.workingTimesList = this.formatWorkingTime(workingTimesListFlat);
      } catch (error) {
        console.error(error);
      }
    },
    formatWorkingTime(workingTimeFlat: any[]): TableTeamStats[] {
      const workingTimeList: TableTeamStats[] = [];
      const userList: string[] = [];
      workingTimeFlat.forEach((item) => {
        if (!userList.includes(item.user.username)) {
          const user = item.user.username;
          let day: number = 0;
          let night = 0;
          let needValidation = false;
          workingTimeFlat.forEach((item2) => {
            if (item2.user.username === user && item2.status === "validated") {
              day += item2.valueDay;
              night += item2.valueNight;
            } else if (
              item2.user.username === user &&
              item2.status === "waiting"
            ) {
              needValidation = true;
            }
          });
          workingTimeList.push({
            id: item.id,
            start: item.start,
            end: item.end,
            valueDay: day,
            valueNight: night,
            user: item.user,
            status: item.status,
            needValidation: needValidation,
          });
          userList.push(item.user.username);
        }
      });
      return workingTimeList;
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
    async getTeamList() {
      const response = await fetch(`${this.apiUrl}/api/teams/manage`, {
        method: "GET",
        credentials: "include",
        headers: {
          "Content-Type": "application/json",
        },
      });
      if (!response.ok) {
        errorHandling(
          response,
          this.snackbarStore,
          this.router,
          this.userStore.logoutUser
        );
        return;
      }
      const data = await response.json();
      this.listTeam = data.data;
      // preselect the first team
      this.queryUuid = this.listTeam[0].id;
      await this.fetchData();
    },
    async fetchTeam() {
      const startTime = this.formatDate(this.end);
      const endTime = this.formatDate(this.start);
      try {
        const response = await fetch(
          `${this.apiUrl}/api/stats/team/workingtimes/average/${this.queryUuid}?start=${startTime}&end=${endTime}`,
          {
            method: "GET",
            credentials: "include",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );
        if (!response.ok) {
          errorHandling(
            response,
            this.snackbarStore,
            this.router,
            this.userStore.logoutUser
          );
          return;
        }
        const data = await response.json();

        this.workingTimesListTeam = data.data.map((w: TeamStats) => ({
          // TODO: create interface to replace any
          ...w,
          day: w.day,
          start: new Date(w.start),
          end: new Date(w.end),
          average_day_hours: w.average_day_hours.toFixed(2),
          average_night_hours: w.average_night_hours.toFixed(2),
          average_hours: w.average_hours.toFixed(2),
          total_day_hours: w.total_day_hours.toFixed(2),
          total_night_hours: w.total_night_hours.toFixed(2),
          total_hours: w.total_hours.toFixed(2),
        }));
      } catch (error) {
        console.error(error);
      }
    },
    async updateAll() {
      await this.fetchTeam();
      await this.fetchData();
    },
  },
  async mounted() {
    await this.getTeamList();
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

.page-wrapper {
  max-width: 80%;
  margin: 0 auto;
}

.button-manager-wrapper {
  display: flex;
  margin-top: 1rem;
  margin-bottom: 1rem;
  justify-content: end;
  flex-direction: row;
  align-items: center;
}
</style>
