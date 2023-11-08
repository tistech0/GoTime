<script setup lang="ts">
import { reactive, ref } from 'vue';
import TextField from '../TextField.vue';
import Button from '../form/Button.vue';
import type { Item } from "../../types/items";
import SelectOne from '../form/SelectOne.vue';
import { useDisplay } from 'vuetify';

let listRoles = ref<Item[]>([]);

const { mobile } = useDisplay()


let data = reactive({
    user: {
        username: "HGefbolij",
        email: 'thisIsASuperTest@test.fr',
        contractTime: 50,
        role: 'Admin',
        password: '123456',
    },
});

</script>


<template>
    <div class="grid grid-cols-5">
        <div class="col-start-3">
            <!-- avatar username -->
            <div class="grid place-content-center -mt-20">
                <img src="https://api.dicebear.com/7.x/notionists/svg?seed={{ data.user.username }}" alt="profile picture"
                    class="w-40 h-40 rounded-ful pb-7" />
            </div>
        </div>
        <!-- icon -->
        <div class="col-start-1 flex place-content-end mr-5">
            <v-btn @click="$router.push('profile')" icon>
                <v-icon>mdi-arrow-left</v-icon>
            </v-btn>
        </div>
        <!--  info -->
        <div :class="{ 'gap-1 mt-1': mobile }"
            class="col-span-3 col-start-2 grid-cols-3 place-content-center mt-20 md:grid flex gap-5 flex-col">
            <!-- username -->
            <div class="grid grid-cols-5 items-center">
                <v-icon class="">mdi-account-outline</v-icon>
                <div class="col-span-4">
                    <TextField label="Username" inputType="username" v-model="data.user.email"
                        inputValue="{{ data.user.username }}" />
                </div>
            </div>
            <!-- email -->
            <div class="grid grid-cols-5 items-center">
                <v-icon class="">mdi-email-outline</v-icon>
                <div class="col-span-4">
                    <TextField label="Email" inputType="email" v-model="data.user.email" />
                </div>
            </div>
            <!-- contract time -->
            <div class=" grid grid-cols-5 items-center">
                <v-icon class="">mdi-briefcase-account-outline</v-icon>
                <div class="col-span-4">
                    <TextField label="ContractTime" inputType="contractTime" v-model="data.user.contractTime" />
                </div>
            </div>
            <!-- role -->
            <div class="grid grid-cols-5 items-center">
                <v-icon>mdi-account-star-outline</v-icon>
                <div class="col-span-4">
                    <SelectOne label="Select a role" :itemList=listRoles hint="Assign a role to the user"
                        v-model="data.user.role" />
                </div>
            </div>
            <div class="grid grid-cols-5 items-center">
                <v-icon>mdi-lock-outline</v-icon>
                <div class="col-span-4">
                    <TextField label="Password" inputType="password" v-model="data.user.password" />
                </div>
            </div>
            <div class="grid grid-cols-5 items-center">
                <v-icon>mdi-lock-check-outline</v-icon>
                <div class="col-span-4">
                    <TextField label="Confirm Password" inputType="password" v-model="data.user.password" />
                </div>
            </div>
        </div>
        <!-- Delete account button -->
        <div class="grid col-span-3 col-start-2 mt-10 mb-10">
            <Button btnColor="blue" buttonName="Update" />
        </div>
    </div>
</template>