<script setup lang="ts">
import { useDisplay } from 'vuetify';
const { mobile } = useDisplay()
</script>

<template>
    <div v-if="!mobile" class="w-full h-full grid grid-row grid-cols-5 grid-flow-row-dense">
        <div class="col-span-full">
            <img src="../../assets/profileBackgroung.png" alt="company" class="w-full h-auto" />
        </div>
    </div>
    <!-- SVG Mobile -->
    <div v-else class="w-full h-full grid grid-row grid-cols-5 grid-flow-row-dense">
        <div class="col-span-full">
            <svg width="100%" height="auto" viewBox="0 0 499 240" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path
                    d="M100.215 234.337C43.818 259.73 9.90628 193.593 0 157.35V0H499V72.935C389.57 116.156 156.611 208.945 100.215 234.337Z"
                    fill="#48A9A6" fill-opacity="0.4" />
            </svg>
        </div>
    </div>
</template>