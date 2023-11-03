<script setup lang="ts">
</script>
<template>
    <div>
        <div class="greetings">
            <!-- image -->
            <img alt="GoTime logo" class="logo" src="../assets/Logo-GoTime.png" width="300" height="300" />
        </div>
        <h1>Master Your Days with GoTime!</h1>
        <p>Team Time Management. Streamline team schedules and track daily time usage effortlessly. Empower your team to
            maximize productivity, together.</p>

        <div class="button">
            <v-btn size="x-large" rounded="lg" elevation="2" color="var(--primary-blue)" class="text-white"
                justify="center">
                Login
            </v-btn>
        </div>
    </div>
</template>

<style scoped>
h1 {
    font-weight: 500;
    font-size: 2rem;
    position: relative;
}

p {
    text-align: center;
}

.button {
    display: flex;
    justify-content: center;
    margin-top: 4rem;
}
</style>
