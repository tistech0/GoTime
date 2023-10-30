<script setup lang="ts">
import { reactive, ref } from 'vue';
import type { Role } from '../types/roles';

const thing = reactive<{ roles: Role[] }>({ roles: [] });

// async function getData() {
//     const res = await fetch("http://localhost:4000/api/users");
//     const { data } = await res.json();
//     console.log(data);
//     thing.roles = data;
// }

let isTicking = ref(false);

const user = {
    username: 'Jean Cristian',
}

const clock = {
    time: '08:00',
}
// getData();
</script>
<template>
    <div class="h-[100vh] bg-cover bg-center bg-[url('../assets/bgCompany.png')]">
        <div class="p-8">
            <p class="pb-5 text-center">
                Hello <span class="text-customSecondary">{{ user.username }}</span>,
            </p>
            <h2>Check-in to work</h2>
            <p class="text-5xl font-semibold text-center pt-15">{{ clock.time }}</p>
            <div v-if="isTicking" class="flex flex-col w-full items-center justify-center pt-10">
                <v-btn color=var(--secondary-pink) class="w-60 mt-8 text-white" @click="() => { isTicking = false; }">
                    Stop your day</v-btn>
                <a>Did you forget to stop your timer?</a>
            </div>
            <div v-else class="flex justify-center pt-10">
                <v-btn color=var(--primary-blue) class="w-60 mt-8 text-white" @click="() => { isTicking = true; }">
                    Start your day</v-btn>
            </div>
        </div>
    </div>
</template>

<style scoped>
h2 {
    @apply text-2xl font-bold text-center;
}
</style>
