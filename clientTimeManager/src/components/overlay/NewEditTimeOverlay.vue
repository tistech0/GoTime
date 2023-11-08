<script setup lang="ts">
  import Button from "../form/Button.vue";
  import {ref} from "vue";
  import {useDisplay} from "vuetify";
  import VueDatePicker from '@vuepic/vue-datepicker';
  import '@vuepic/vue-datepicker/dist/main.css'

  const props = defineProps({title: String, startDate: Date, endDate: Date});
  const showPopup = ref(false);

  const { mobile } = useDisplay()
  const openPopup = () => {
    showPopup.value = true;
  };

  const closePopup = () => {
    showPopup.value = false;
  };
  const startDate = ref(new Date());
  const endDate = ref(new Date());
  const dpStart = ref();
  const dpEnd = ref();
  const selectDateStart = () => {
    dpStart.value.selectDate();
  }
  const selectDateEnd = () => {
    dpEnd.value.selectDate();
  }

  if (props.startDate) {
    startDate.value = props.startDate;
  }
  if (props.endDate) {
    endDate.value = props.endDate;
  }
  defineExpose({openPopup, closePopup});

</script>

<template>
  <div class="fixed inset-0 flex items-center justify-center z-2" v-if="showPopup">
    <div class="absolute inset-0 bg-black opacity-50"></div>
    <div :class="{'bg-white p-6 rounded-lg shadow-lg z-10': true, 'mobile-class': mobile}">
      <div class="grid grid-cols-2 items-start">
        <v-icon class="mt-2 col-start-2 justify-self-end" @click="closePopup">mdi-window-close</v-icon>
        <div class="col-span-2">
          <h1 class="text-black font-semibold">{{ props.title }}</h1>
          <div class="mx-2 mb-4">
            <label for="startDate" class="text-gray-500 font-semibold">Starting Time</label>
            <VueDatePicker v-model="startDate" time-picker-inline id="startDate" ref="dpStart">
              <template #action-buttons>
                <button class="custom-button" @click="selectDateStart">Select</button>
              </template>
            </VueDatePicker>
          </div>
          <div class="mx-2 mb-4">
            <label for="endDate" class="text-gray-500 font-semibold">End Time</label>
            <VueDatePicker v-model="endDate" time-picker-inline id="startDate" ref="dpEnd">
              <template #action-buttons>
                <button class="custom-button" @click="selectDateEnd">Select</button>
              </template>
            </VueDatePicker>
          </div>
        </div>
      </div>
      <Button buttonName="Validate" btn-color="blue" @on-click="closePopup"/>
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