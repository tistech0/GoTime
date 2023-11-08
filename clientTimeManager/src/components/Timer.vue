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
      clock: 0.0,
      isTicking: false,
      user: {
        username: 'john',
        surname: 'doe'
      }
    }
  },
  methods: {
    updateClock() {
      this.isTicking = !this.isTicking;
      console.log("is ticking")
    }
  }
}
</script>

<style scoped>
h2 {
  @apply text-2xl font-bold text-center;
}
</style>
