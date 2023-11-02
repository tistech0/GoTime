<script setup lang="ts">
import { useDisplay } from 'vuetify';
const props = defineProps<{ buttonName: string }>()
const emit = defineEmits(["onClick"]);

const { mobile } = useDisplay()

</script>

<template>
    <div class="button">
        <v-btn :class="mobile ? 'full-width-button' : 'small-width-button' " color="var(--primary-blue)" @click="$emit('onClick')">
            {{ props.buttonName }}
        </v-btn>
    </div>
</template>

<style scoped>
.button {
    display: flex;
    justify-content:center;
}
.small-width-button {
    width: 50%;
}
.full-width-button {
    width: 100%;
}
</style>