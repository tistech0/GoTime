<script setup lang="ts">
import { useDisplay } from 'vuetify';

const props = defineProps<{ buttonName: string, btnColor: string }>()

const emit = defineEmits(["onClick"]);

const { mobile } = useDisplay()

</script>

<template>
    <div class="button">
        <v-btn :class="mobile ? 'full-width-button' : 'small-width-button'"
            :color="btnColor == 'blue' ? 'var(--primary-blue)' : 'var(--secondary-pink)'" @click="$emit('onClick')"
        class="text-white">
            {{ props.buttonName }}
        </v-btn>
    </div>
</template>

<style scoped>
.button {
    display: flex;
    justify-content: center;
}

.small-width-button {
    @apply w-1/2
}

.full-width-button {
    @apply w-full
}
</style>