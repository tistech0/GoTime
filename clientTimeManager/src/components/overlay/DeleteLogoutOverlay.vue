<script setup lang="ts">
import Button from "../form/Button.vue";
import {ref} from "vue";
import {useDisplay} from "vuetify";

const props = defineProps({title: String, description: String});
const showPopup = ref(false);
const { mobile } = useDisplay()


const openPopup = () => {
  showPopup.value = true;
};

const closePopup = () => {
  showPopup.value = false;
};

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
          <p class="font-semibold m-4 text-center">{{ props.description }}</p>
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
</style>



