<script setup lang="ts">
import { ref, defineEmits, defineProps, watch } from 'vue';

const props = defineProps({
  modelValue: [String, Number],
  label: String,
  inputType: String,
  disable: Boolean,
  hint: String
});

const emit = defineEmits(["update:modelValue"]);

let localInputValue = ref(props.modelValue);

watch(() => props.modelValue, (newVal) => {
  localInputValue.value = newVal;
});

const handleChange = (event: any) => {
    emit("update:modelValue", event.target.value);
};

</script>

<template>
  <div>
    <v-text-field bg-color="var(--primary-blue-light)" :label=props.label :type=props.inputType clearable
                  :disabled="props.disable" v-model=localInputValue variant="solo-filled" :hint=props.hint @input="handleChange">
    </v-text-field>
  </div>
</template>
