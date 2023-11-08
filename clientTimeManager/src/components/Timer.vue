<template>
  <div class="h-[100vh] bg-cover bg-center bg-[url('../assets/bgCompany.png')]">
    <div class="p-8">
      <p class="pb-5 text-center">
        Hello <span class="text-customSecondary">{{ user.username }}</span>,
      </p>
      <h2>Check-in to work</h2>
      <p class="text-5xl font-semibold text-center pt-15">{{ clock }}</p>
      <div v-if="isTicking" class="flex flex-col w-full items-center justify-center pt-10">
        <v-btn color=var(--secondary-pink) class="w-60 mt-8 text-white" @click="updateClock">
          Stop your day</v-btn>
        <a>Did you forget to stop your timer?</a>
      </div>
      <div v-else class="flex justify-center pt-10">
        <v-btn color=var(--primary-blue) class="w-60 mt-8 text-white" @click="updateClock">
          Start your day</v-btn>
      </div>
    </div>
  </div>
</template>

<script lang="ts">

export default {
  data() {
    return {
      clock: "00:00:00",
      isTicking: false,
      intervalId: null,
      user: {
        username: 'john',
        surname: 'doe'
      }
    }
  },
  methods: {
    updateClock() {
      this.isTicking = !this.isTicking;
      if (this.isTicking) {
        this.startTime = new Date();
        this.clock = '00:00:00';
        this.intervalId = setInterval(() => {
          let elapsedTime = new Date() - this.startTime;
          let seconds = Math.floor((elapsedTime / 1000) % 60);
          let minutes = Math.floor((elapsedTime / (1000 * 60)) % 60);
          let hours = Math.floor((elapsedTime / (1000 * 60 * 60)) % 24);
          this.clock = (hours < 10 ? '0' + hours : hours) + ':' +
              (minutes < 10 ? '0' + minutes : minutes) + ':' +
              (seconds < 10 ? '0' + seconds : seconds);
        }, 1000);
      } else {
        clearInterval(this.intervalId);
      }
    }
  }
}
</script>

<style scoped>
h2 {
  @apply text-2xl font-bold text-center;
}
</style>
