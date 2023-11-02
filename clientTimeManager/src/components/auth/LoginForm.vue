<script setup lang="ts">

import { ref } from 'vue';
import TextField from '../form/TextField.vue';
import Button from '../form/Button.vue';
import { useDisplay } from 'vuetify';

const { lg } = useDisplay()


const loginFormData = ref({
    user: {
        email: "",
        password: ""
    }
})


// Form submition for login
async function handleSubmit() {

    // Encrypt password with bcrypt

    const response = await fetch("http://localhost:4000/api/users/log_in", {
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
    const data = await response.json();

    console.log(data);

}


</script>

<template>
    <div class="grid grid-cols-1" :class="lg ? 'login-large' : 'login-small'">
        <div>
            <h1 class="text-customSecondary">LOGIN</h1>
            <p class="welcome-message">Welcome back, you've been missed!</p>
        </div>
        <form :class="!lg ? 'text-input' : ''">
            <TextField label="Enter your Email" inputType="email" v-model="loginFormData.user.email" />
            <TextField label="Enter your Password" inputType="password" v-model="loginFormData.user.password" />
            <Button buttonName="Login" type="submit" @click=handleSubmit()></Button>
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
.login-small {
    margin: 5rem 1rem;
}

.text-input {
    padding: 0 1rem 0 1rem;
}
</style>