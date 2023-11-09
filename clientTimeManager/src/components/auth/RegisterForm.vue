<script setup lang="ts">

import { ref } from 'vue';
import TextField from '../form/TextField.vue';
import SelectOne from '../form/SelectOne.vue';
import Button from '../form/Button.vue';
import { useDisplay } from 'vuetify';
import myImage from '../../assets/Logo-GoTime.png';
import type { Item } from "../../types/items";
import { transformData, errorHandling } from "../../utils/utils";
import { useRouter } from 'vue-router';
import { useSnackbarStore } from '@/stores/snackbar';
import { Role } from '../../constants/RoleEnum'



const { lg, mobile } = useDisplay()
const router = useRouter();
const snackbarStore = useSnackbarStore();
const apiUrl = import.meta.env.VITE_API_URL;



// Initialize the list of teams as a list of Item
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
        role_id: "" // Is the selected role id
    },
    team : {
        id: "" // Is the selected team id
    }
})

/**
 *  This function fetchs the list of roles from the api and assign the value to the listRoles
 */
async function getRoleList() {
    const response = await fetch(`${apiUrl}/api/roles`, {
        method: "GET",
        credentials: "include",
        headers: {
            'Content-Type': 'application/json'
        }
    });
    if (!response.ok) {
        errorHandling(response, snackbarStore, router);
        return
    }
    const data = await response.json();
    // Set the enum values for the roles
    const dataWithFormattedRole = data.data.map((role: any) => ({
        id: role.id,
        role: Role[role.role as keyof typeof Role] || role.role, // Use the enum value if available, or the original value
    }));
    listRoles.value = transformData(dataWithFormattedRole, "id", "role");
}

// Fetch the role list the user has access to.
getRoleList();

/**
 *  This function fetchs the list of teams from the api and assign the value to the listTeam
 */
async function getTeamList() {
    const response = await fetch(`${apiUrl}/api/teams/manage`, {
        method: "GET",
        credentials: "include",
        headers: {
            'Content-Type': 'application/json'
        }
    });
    if (!response.ok) {
        errorHandling(response, snackbarStore, router);
        return
    }
    const data = await response.json();
    listTeam.value = data.data;
}

// Fetch the team list the user has access to.
getTeamList();


// Form submition for creating a new account
async function handleSubmit() {

    // Encrypt password with bcrypt

    // Check the two password are equals
    if (registerFormData.value.user.password !== registerFormData.value.user.confirmPassword) {
        snackbarStore.showSnackbar('Both password need to be the same', 2000, 'error');
        registerFormData.value.user.confirmPassword = ""
        return
    }
    // Reset confirm password as it is unfiltered by phoenix and useless
    registerFormData.value.user.confirmPassword = ""

    console.log(registerFormData.value)

    // Create the new account
    const response = await fetch(`${apiUrl}/api/users`, {
            method: 'POST',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(registerFormData.value)
        });
    if (!response.ok) {
        errorHandling(response, snackbarStore, router);
        return
    }
}


</script>

<template>
    <div class="grid grid-cols-1 register">
        <div v-if="mobile" class="logo-container">
            <v-img aspect-ratio="1/1" cover width="9rem" :src="myImage">
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
            <TextField label="Contract time" input-type="number" hint="The employee's weekly hours"
                v-model.number="registerFormData.user.time_contract" />
            <SelectOne label="Select a team" :itemList=listTeam hint="Assign the employee to a team"
                v-model="registerFormData.team.id" :clearable=true />
            <SelectOne label="Select a role" :itemList=listRoles hint="Assign a role to the" :clearable=false
                v-model="registerFormData.user.role_id" />
            <Button btnColor="blue" buttonName="Create Account" type="submit" @click=handleSubmit()></Button>
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