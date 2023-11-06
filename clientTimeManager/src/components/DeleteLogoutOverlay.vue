<script setup lang="ts">
import Button from "../components/form/Button.vue";
import {ref} from "vue";

const props = defineProps({title: String, description: String});
const showPopup = ref(false);


const openPopup = () => {
  showPopup.value = true;
};

const closePopup = () => {
  showPopup.value = false;
};

defineExpose({openPopup, closePopup});
</script>

<template>
  <div class="fixed inset-0 flex items-center justify-center z-50" v-if="showPopup">
    <div class="absolute inset-0 bg-black opacity-50"></div>
    <div class="bg-white p-6 rounded-lg shadow-lg z-10">
      <div class="flex justify-between items-start">
        <div>
          <h1 class="text-black font-semibold m-7">{{ props.title }}</h1>
          <p class="font-semibold m-4">{{ props.description }}</p>
        </div>
        <v-icon class="mt-2" @click="closePopup">mdi-window-close</v-icon>
      </div>
      <Button buttonName="Validate" @on-click="closePopup"/>
    </div>
  </div>
</template>



