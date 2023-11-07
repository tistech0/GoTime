<script setup lang="ts">
import BottomNav from '@/components/BottomNav.vue';
import Sidebar from '@/components/SideBar.vue';
import { useDisplay } from 'vuetify';


const { mobile } = useDisplay()
</script>

<template>
    <BottomNav v-if="mobile" />
    <Sidebar v-else />
    <v-main class="w-full h-full grid grid-cols-5 grid-flow-row-dense">

    </v-main>
</template>
