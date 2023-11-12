<script setup lang="ts">
import type { Item } from "../../types/items";
import { ref, defineEmits, defineProps, watch } from 'vue';

const props = defineProps({ clearable: Boolean, label: String, itemList: Array<Item>, hint: { type: String, default: "" }, modelValue: [String, Number], disable: Boolean})
const emit = defineEmits(["update:modelValue"]);

let selectedValue = ref(props.modelValue);

watch(() => props.modelValue, (newVal) => {
  selectedValue.value = newVal;
});

const handleChange = (value: any) => {
    emit("update:modelValue", value);
};

</script>

<template>
    <div>
        <v-select bg-color="var(--primary-blue-light)" :label=props.label :hint=props.hint :items=itemList item-title="name"
            item-value="id" v-model="selectedValue" variant="solo-filled" :clearable=props.clearable :disabled="props.disable"
            @update:model-value="handleChange"></v-select>

    </div>
</template>

<style scoped></style>
