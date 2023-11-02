<script setup lang="ts">
import myImage from '../../assets/Logo-GoTime.png';
import { useDisplay } from 'vuetify';

const { md } = useDisplay()


</script>

<template>
    <div class="grid grid-cols-1 banner">
        <div class="logo-container">
            <v-img
                aspect-ratio="1/1"
                cover
                :width="!md ? '20rem' : '12rem'"
                :src="myImage">
            </v-img>
        </div>
        <div class="banner-text">
            <div class="banner-headlines text-customPrimary">
                <p>No registered account yet?</p>
                <p>Ask your manager</p>
            </div>
            <div>
                <p>Team Time Management. Streamline team schedules and track daily time usage effortlessly. Empower your team to maximize productivity, together.</p>
            </div>
        </div>
    </div>
</template>

<style scoped>
.banner {
    padding: 0 0.5rem
}

.logo-container {
    margin: auto;
}

.banner-text {
    text-align: center;
    font-weight: 600;
}

.banner-headlines {
    font-size: x-large;
    margin-bottom: 1rem;
}
</style>