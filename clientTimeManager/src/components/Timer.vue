<template>
  <div class="h-[100vh] bg-cover bg-center bg-[url('../assets/bgCompany.png')]">
    <div class="p-8">
      <p class="pb-5 text-center">
        Hello <span class="text-customSecondary">{{ username }}</span
        >,
      </p>
      <h2>Check-in to work</h2>
      <p class="text-5xl font-semibold text-center pt-15">{{ clock }}</p>
      <div
        v-if="isTicking"
        class="flex flex-col w-full items-center justify-center pt-10"
      >
        <v-btn
          color="var(--secondary-pink)"
          class="w-60 mt-8 text-white"
          @click="updateClock"
        >
          Stop your day</v-btn
        >
        <a>Did you forget to stop your timer?</a>
      </div>
      <div v-else class="flex justify-center pt-10">
        <v-btn
          color="var(--primary-blue)"
          class="w-60 mt-8 text-white"
          @click="updateClock"
        >
          Start your day</v-btn
        >
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import type { Clock } from "@/types/clock";
import { useUserStore } from "@/stores/user";
import { errorHandling } from "@/utils/utils";
import { useSnackbarStore } from "@/stores/snackbar";
import { useRouter } from "vue-router";

export default {
  props: {
    username: {
      type: String,
      required: true,
    },
  },
  data() {
    const userStore = useUserStore();
    const user = userStore.getUser;

    return {
      clock: "00:00:00",
      clockData: null as unknown as Clock,
      isTicking: false,
      intervalId: 0 as unknown as NodeJS.Timeout,
      startTime: new Date(),
      userId: user?.id,
      userStore: userStore,
      snackbarStore: useSnackbarStore(),
      router: useRouter(),
    };
  },
  methods: {
    async updateClock() {
      this.isTicking = !this.isTicking;
      if (this.isTicking) {
        this.startTime = new Date();
        await this.updateClockApi(this.startTime);
        this.clock = "00:00:00";
        this.intervalId = setInterval(() => {
          let elapsedTime: number =
            (new Date() as Date).getTime() - (this.startTime as Date).getTime();
          let seconds = Math.floor((elapsedTime / 1000) % 60);
          let minutes = Math.floor((elapsedTime / (1000 * 60)) % 60);
          let hours = Math.floor((elapsedTime / (1000 * 60 * 60)) % 24);
          this.clock =
            (hours < 10 ? "0" + hours : hours) +
            ":" +
            (minutes < 10 ? "0" + minutes : minutes) +
            ":" +
            (seconds < 10 ? "0" + seconds : seconds);
        }, 1000);
      } else {
        clearInterval(this.intervalId);
        this.clock = "00:00:00";
        await this.updateClockApi(new Date());
        this.$emit("clock-stoped");
      }
    },
    async getClock() {
      const apiUrl = import.meta.env.VITE_API_URL;

      const response = await fetch(`${apiUrl}/api/clocks/${this.userId}`, {
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
      return await response.json();
    },
    async updateClockApi(date: Date) {
      const apiUrl = import.meta.env.VITE_API_URL;

      const response = await fetch(`${apiUrl}/api/clocks/${this.userId}`, {
        method: "POST",
        credentials: "include",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          clock: {
            time: this.formatDate(date),
          },
        }),
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
      return await response.json();
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
  },
  async mounted() {
    this.clockData = await this.getClock().then((data) => data.data);
    this.isTicking = this.clockData.status;
    if (this.isTicking) {
      this.startTime = new Date(this.clockData.time);
      this.intervalId = setInterval(() => {
        let elapsedTime: number =
          (new Date() as Date).getTime() - (this.startTime as Date).getTime();
        let seconds = Math.floor((elapsedTime / 1000) % 60);
        let minutes = Math.floor((elapsedTime / (1000 * 60)) % 60);
        let hours = Math.floor((elapsedTime / (1000 * 60 * 60)) % 24);
        this.clock =
          (hours < 10 ? "0" + hours : hours) +
          ":" +
          (minutes < 10 ? "0" + minutes : minutes) +
          ":" +
          (seconds < 10 ? "0" + seconds : seconds);
      }, 1000);
    }
  },
};
</script>

<style scoped>
h2 {
  @apply text-2xl font-bold text-center;
}
</style>
