<template>
  <div class="selector-wrapper">
    <v-icon class="arrow" @click="goBackOneWeek">mdi-arrow-left-drop-circle-outline</v-icon>
    <p class="week-display">{{ formatDate(oneWeekAgo) }} - {{ formatDate(currentDate) }}</p>
    <v-icon class="arrow" @click="goNextOneWeek" v-if="shouldShowArrow">mdi-arrow-right-drop-circle-outline</v-icon>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  data() {
    return {
      currentDate: new Date(),
      oneWeekAgo: this.initOneWeekAgo(),
      shouldShowArrow: false,
    };
  },
  methods: {
    initOneWeekAgo() {
      let week = new Date();
      week.setDate(week.getDate() - 6);
      return week;
    },
    formatDate(date: Date) {
      return date.toLocaleDateString('fr', {
        month: 'long',
        day: 'numeric',
      });
    },
    goBackOneWeek() {
      this.currentDate.setDate(this.currentDate.getDate() - 6);
      this.checkCurrentDate();
      this.oneWeekAgo = new Date(this.currentDate);
      this.oneWeekAgo.setDate(this.oneWeekAgo.getDate() - 6);
    },
    goNextOneWeek() {
      this.currentDate.setDate(this.currentDate.getDate() + 6);
      this.checkCurrentDate();
      this.oneWeekAgo = new Date(this.currentDate);
      this.oneWeekAgo.setDate(this.oneWeekAgo.getDate() - 6);
    },
    checkCurrentDate() {
      this.shouldShowArrow = this.formatDate(this.currentDate) !== this.formatDate(new Date());
      this.$emit('week-updated', this.currentDate);
    },
  },
});
</script>

<style scoped>
.selector-wrapper {
  display: flex;
  justify-content: space-around;
  align-items: center;
  margin: 1rem 0;
  width: 250px;
  margin-left: auto;
  margin-right: 50px;
}
</style>
