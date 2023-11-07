<script setup lang="ts">

import { ref } from 'vue';
import TextField from '../form/TextField.vue';
import CustomButton from '../form/Button.vue';
import { useDisplay } from 'vuetify';
import myImage from '../../assets/Logo-GoTime.png';
import { useUserStore } from '@/stores/user'


const { lg, mobile } = useDisplay()

const storedUser = useUserStore()

const loginFormData = ref({
    user: {
        email: "",
        password: ""
    }
})


// Form submition for login
async function handleSubmit() {

    // TODO: Encrypt password with bcrypt

    const response = await fetch("/api/users/log_in", {
            method: 'POST',
            credentials: 'include',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(loginFormData.value)
        });
        
    if (!response.ok) {
        console.log(response)
    }
    // Get the data in json format
    const data = await response.json();

    // Replace all the user data contained in the storedUser
    storedUser.$state = data.data; 
}
</script>

<template>
    <div class="grid grid-cols-1" :class="[lg ? 'login-large' : 'login-medium',mobile ? 'login-small' : '']">
        <div v-if="mobile" class="logo-container">
            <v-img
                aspect-ratio="1/1"
                cover
                width="9rem"
                :src="myImage">
            </v-img>
        </div>
        <div>
            <h1 class="text-customSecondary">LOGIN</h1>
            <p class="welcome-message">Welcome back, you've been missed!</p>
        </div>
        <form :class="!lg ? 'text-input' : ''">
            <TextField label="Enter your Email" inputType="email" v-model="loginFormData.user.email" />
            <TextField label="Enter your Password" inputType="password" v-model="loginFormData.user.password" />
            <CustomButton buttonName="Login" btn-color="blue" type="submit" @click=handleSubmit()></CustomButton>
        </form>
    </div>
</template>

<style scoped>
.welcome-message {
    font-weight: 600;
    font-size: 1rem;
    text-align: center;
}
.login-large {
    margin: 5rem;
}
.login-medium {
    margin: 5rem 1rem;
}
.login-small {
    margin: 1rem 1rem;
}
.text-input {
    padding: 0 1rem 0 1rem;
}

.logo-container {
    margin: auto;
}
</style>