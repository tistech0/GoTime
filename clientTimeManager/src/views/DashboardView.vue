<script setup lang="ts">
import { useDisplay } from 'vuetify';
import WeekSelector from "@/components/WeekSelector.vue";
const { mobile } = useDisplay()
</script>

<template>
  <BottomNav v-if="mobile" />
  <Sidebar v-else />
  <v-main class="w-full h-full grid grid-cols-5 grid-flow-row-dense">
    <Timer class=" col-span-2"/>
    <div class="data-wrapper col-span-3">
      <WeekSelector @week-updated="updateWeek"/>
      <TimeGraph :start="start" :end="end" :key="`${start}-${end}`"/>
    </div>
  </v-main>
</template>

<script lang="ts">
import BottomNav from '../components/BottomNav.vue';
import Sidebar from '../components/SideBar.vue';
import Timer from '../components/Timer.vue';
import TimeGraph from '../components/TimeGraph.vue';

export default {
  components: { Timer, BottomNav, Sidebar, TimeGraph },
  data() {
    return {
      start: new Date(),
      end: this.initOneWeekAgo(),
    };
  },
  methods : {
    initOneWeekAgo() {
      let week = new Date();
      week.setDate(week.getDate() - 6);
      return week;
    },
    updateWeek(currentDate: Date) {
      this.start = new Date(currentDate);
      this.end = new Date(currentDate);
      this.end.setDate(this.end.getDate() - 6);
      console.log("start: start", this.start, "end: ", this.end);
    }
  }
};

</script>

<style scoped></style>
