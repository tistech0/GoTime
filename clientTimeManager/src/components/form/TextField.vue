<script setup lang="ts">
import { ref, defineEmits, defineProps } from 'vue';

const props = defineProps<{ label: string, inputType: string, modelValue: string }>()
const emit = defineEmits(["update:modelValue"]);

const inputValue = ref("");

const handleChange = () => {
  emit("update:modelValue", inputValue.value);
};

</script>

<template>
    <div>
        <v-text-field
            bg-color="var(--primary-blue-light)"
            :label= props.label
            :type= props.inputType
            clearable
            v-model= inputValue
            variant="solo-filled"
            @input="handleChange">
        </v-text-field>
    </div>
</template>

<style scoped>


</style>
