<script setup lang="ts">
import { ref, defineEmits, defineProps } from 'vue';

const props = defineProps({ label: String, itemList: Array, hint: { type: String, default: "" }, modelValue: [String, Number] })
const emit = defineEmits(["update:modelValue"]);

const selectedValue = ref("");

function handleChange () {
console.log(selectedValue.value);
  emit("update:modelValue", selectedValue.value);
};

</script>

<template>
    <div>
        <v-select
            bg-color="var(--primary-blue-light)"
            :label= props.label
            :hint= props.hint
            :items= props.itemList
            item-title="name"
            item-value="id"
            v-model= selectedValue
            variant="solo-filled"
            clearable
            @input="handleChange">
        </v-select>

    </div>
</template>

<style scoped>


</style>
