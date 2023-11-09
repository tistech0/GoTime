<script setup lang="ts">
import { ref, defineEmits, defineProps } from 'vue';

const emit = defineEmits(["update:modelValue"]);

const inputValue = ref("");

const handleChange = () => {
    emit("update:modelValue", inputValue.value);
};

</script>

<template>
  <div>
    <v-text-field bg-color="var(--primary-blue-light)" :label=label :type=inputType clearable
                  :disabled="disable" v-model=localInputValue variant="solo-filled" :hint=hint @input="handleChange">
    </v-text-field>
  </div>
</template>

<script lang="ts">
export default {
  props: ['inputValue', 'label', 'inputType', 'disable', 'hint'],
  data() {
    return {
      localInputValue: this.inputValue,
    };
  },
  watch: {
    inputValue(newVal) {
      this.localInputValue = newVal;
    },
  },
};
</script>
