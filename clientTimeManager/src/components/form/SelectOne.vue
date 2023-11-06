<script setup lang="ts">
import type { Item } from "../../types/items";
import { ref, defineEmits, defineProps } from 'vue';

const props = defineProps({ label: String, itemList: Array<Item>, hint: { type: String, default: "" }, modelValue: [String, Number] })
const emit = defineEmits(["update:modelValue"]);

const selectedValue = ref();

const handleChange =  ()  =>{
  emit("update:modelValue", selectedValue.value);
};

</script>

<template>
    <div>
        <v-select
            bg-color="var(--primary-blue-light)"
            :label= props.label
            :hint= props.hint
            :items=itemList
            item-title="name"
            item-value="id"
            v-model="selectedValue"
            variant="solo-filled"
            clearable
            @update:model-value="handleChange"
        ></v-select>

    </div>
</template>

<style scoped>


</style>
