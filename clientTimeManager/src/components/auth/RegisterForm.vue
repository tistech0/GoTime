<script setup lang="ts">

import { ref } from 'vue';
import TextField from '../form/TextField.vue';
import SelectOne from '../form/SelectOne.vue';
import Button from '../form/Button.vue';
import { useDisplay } from 'vuetify';
import myImage from '../../assets/Logo-GoTime.png';
import type { Item } from "../../types/items";
import { transformData } from "../../utils/utils";



const { lg, mobile } = useDisplay()

// fetch the user's managed teams in stead of this static code. 
const listTeam = ref<Item[]>([]);

// Initialize the list of roles as a list of Item
let listRoles = ref<Item[]>([]);


const registerFormData = ref({
    user: {
        email: "",
        username: "",
        password: "",
        confirmPassword: "",
        time_contract: 0,
        team: 0, // Is the selected team id
        role: 0 // Is the selected role id
    }
})

/**
 * This function gets the list of roles from the api and assign the value to the listRoles
 */
async function getRoleList() {
    const response = await fetch("http://localhost:4000/api/roles", {
        method: "GET",
        credentials: "include",
        headers: {
            'Content-Type': 'application/json'
        }
    });
    const data = await response.json();
    listRoles.value = transformData(data.data, "id", "role");
}

// Fetch the role list the user has access to.
getRoleList();


async function getTeamList() {
    const response = await fetch("http://localhost:4000/api/teams/manage", {
        method: "GET",
        credentials: "include",
        headers: {
            'Content-Type': 'application/json'
        }
    });
    const data = await response.json();
    listTeam.value = data.data;
}

// Fetch the team list the user has access to.
getTeamList();


// Form submition for creating a new account
async function handleSubmit() {

    // Encrypt password with bcrypt

    // Create the new account
    // const response = await fetch("http://localhost:4000/api/users", {
    //         method: 'POST',
    //         credentials: 'include',
    //         headers: {
    //             'Content-Type': 'application/json'
    //         },
    //         body: JSON.stringify(registerFormData.value)
    //     });
        
    // if (!response.ok) {
    //     console.log(response)
    // }
    // const data = await response.json();

    console.log(registerFormData.value);

}


</script>

<template>
    <div class="grid grid-cols-1 register">
        <div v-if="mobile" class="logo-container">
            <v-img
                aspect-ratio="1/1"
                cover
                width="9rem"
                :src="myImage">
            </v-img>
        </div>
        <div>
            <h1 class="text-customSecondary">CREATE A NEW ACCOUNT</h1>
        </div>
        <form :class="!lg ? 'text-input' : ''">
            <TextField label="Email" inputType="email" v-model="registerFormData.user.email" />
            <TextField label="Username" inputType="text" v-model="registerFormData.user.username" />
            <TextField label="Password" inputType="password" v-model="registerFormData.user.password" />
            <TextField label="Confirm Password" input-type="password" v-model="registerFormData.user.confirmPassword" />
            <TextField label="Contract time" input-type="number" hint="The employee's weekly hours" v-model.number="registerFormData.user.time_contract" />
            <SelectOne label="Select a team" :itemList=listTeam hint="Assign the employee to a team" v-model="registerFormData.user.team" />
            <SelectOne label="Select a role" :itemList=listRoles hint="Assign a role to the" v-model="registerFormData.user.role" />
            <Button buttonName="Create Account" type="submit" @click=handleSubmit()></Button>
        </form>
    </div>
</template>

<style scoped>
.welcome-message {
    font-weight: 600;
    font-size: 1rem;
    text-align: center;
}
.register {
    margin: 1rem 1rem;
}
.text-input {
    padding: 0 1rem 0 1rem;
}

.logo-container {
    margin: auto;
}
</style>