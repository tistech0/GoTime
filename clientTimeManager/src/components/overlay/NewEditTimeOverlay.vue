<script setup lang="ts">
import Button from "../form/Button.vue";
import { ref } from "vue";
import { useDisplay } from "vuetify";
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";
import type { WorkingTime } from "../../types/workingTime";

const props = defineProps<{
  title: string;
  visible: boolean;
  item?: WorkingTime;
  onAction: () => void;
}>();

defineEmits(["update:visible", "update:item"]);

const { mobile } = useDisplay();

const itemInfo = ref<WorkingTime>(
  props.item ?? {
    start: new Date(),
    end: new Date(),
    status: "waiting",
  }
);

const dpStart = ref();
const dpEnd = ref();

const selectDateStart = () => {
  dpStart.value.selectDate();
};
const selectDateEnd = () => {
  dpEnd.value.selectDate();
};
</script>

<template>
  <div class="fixed inset-0 flex items-center justify-center z-10">
    <div class="absolute inset-0 bg-black opacity-50"></div>
    <div
      :class="{
        'bg-white p-6 rounded-lg shadow-lg z-10': true,
        'mobile-class': mobile,
      }"
    >
      <div class="grid grid-cols-2 items-start">
        <v-icon
          class="mt-2 col-start-2 justify-self-end"
          @click="$emit('update:visible', false)"
          >mdi-window-close</v-icon
        >
        <div class="col-span-2">
          <h1 class="text-black font-semibold">{{ props.title }}</h1>
          <div class="mx-2 mb-4">
            <label for="startDate" class="text-gray-500 font-semibold"
              >Starting Time</label
            >
            <VueDatePicker
              v-model="itemInfo.start"
              time-picker-inline
              id="startDate"
              ref="dpStart"
            >
              <template #action-buttons>
                <button class="custom-button" @click="selectDateStart">
                  Select
                </button>
              </template>
            </VueDatePicker>
          </div>
          <div class="mx-2 mb-4">
            <label for="endDate" class="text-gray-500 font-semibold"
              >End Time</label
            >
            <VueDatePicker
              v-model="itemInfo.end"
              time-picker-inline
              id="startDate"
              ref="dpEnd"
            >
              <template #action-buttons>
                <button class="custom-button" @click="selectDateEnd">
                  Select
                </button>
              </template>
            </VueDatePicker>
          </div>
        </div>
      </div>
      <Button
        buttonName="Validate"
        btn-color="blue"
        @click="
          () => {
            $emit('update:visible', false);
            props.onAction();
          }
        "
      />
    </div>
  </div>
</template>

<style>
.mobile-class {
  margin-left: 10px;
  margin-right: 10px;
}
.custom-button {
  background-color: gray;
  color: white;
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.custom-button.selected {
  background-color: red;
  color: white;
}
</style>
