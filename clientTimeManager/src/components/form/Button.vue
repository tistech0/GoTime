<script setup lang="ts">
const props = defineProps<{ buttonName: string }>()
const emit = defineEmits(["onClick"]);
</script>

<template>
    <div class="button">
        <v-btn color="var(--primary-blue)" @click="$emit('onClick')">
            {{ buttonName }}
        </v-btn>
    </div>
</template>

<style scoped>
.button {
    display: flex;
    justify-content:center;
}
</style>