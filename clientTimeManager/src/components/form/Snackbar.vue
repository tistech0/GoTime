<script setup lang="ts">
import { computed } from 'vue';

import { useSnackbarStore } from '@/stores/snackbarStore';

const snackbarStore = useSnackbarStore();
const isOpen = computed(() => snackbarStore.isOpen);
const message = computed(() => snackbarStore.message);
const color = computed(() => snackbarStore.color);

</script>

<template>
        <v-snackbar 
            v-model=isOpen
            elevation="20"
            :color="color == 
            'error' ? 'var(--error-red-light)' :
            'var(--success-green-light)'"
            class="text-center"
        >
            {{ message }}
        </v-snackbar>
</template>