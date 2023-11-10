<script setup lang="ts">

import { ref } from 'vue';
import TextField from '@/components/form/TextField.vue';
import Button from '@/components/form/Button.vue';
import { useDisplay } from 'vuetify';
import myImage from '@/assets/Logo-GoTime.png';
import { useRouter } from 'vue-router';
import { errorHandling } from "@/utils/utils";
import { useUserStore } from '@/stores/user';
import { useSnackbarStore } from '@/stores/snackbar';
import { routeNames } from '@/router/index';



const { lg, mobile } = useDisplay()
const userStore = useUserStore()
const snackbarStore = useSnackbarStore();
const router = useRouter();

const loginFormData = ref({
    user: {
        email: "",
        password: ""
    }
})


// Form submition for login
async function handleSubmit() {

    // TODO: Encrypt password with bcrypt
  const apiUrl = import.meta.env.VITE_API_URL;
  const response = await fetch(`${apiUrl}/api/users/log_in`, {
    method: 'POST',
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(loginFormData.value)
  });

    if (!response.ok) {
        errorHandling(response, snackbarStore, router);
        return
    }
    // Get the data in json format
    const data = await response.json();
    // Replace all the user data contained in the storedUser
    userStore.loginUser(data.data)
    router.push({name : routeNames.home})
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
            <Button btnColor="blue" buttonName="Login" type="submit" @click=handleSubmit()></Button>
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