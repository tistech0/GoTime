<script setup lang="ts">
import { ref, defineEmits, defineProps } from 'vue';

const props = defineProps({ label: String, inputType: String, hint: { type: String, default: "" }, modelValue: [String, Number], disable: { type: Boolean, default: false } })
const emit = defineEmits(["update:modelValue"]);

const inputValue = ref("");

const handleChange = () => {
    emit("update:modelValue", inputValue.value);
};

</script>

<template>
    <div>
        <v-text-field bg-color="var(--primary-blue-light)" :label=props.label :type=props.inputType clearable
            :disabled="props.disable" v-model=inputValue variant="solo-filled" :hint=props.hint @input="handleChange">
        </v-text-field>
    </div>
</template>