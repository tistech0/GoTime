<script lang="ts" setup>
import { useDisplay } from 'vuetify';

const { smAndUp } = useDisplay()
</script>

<template>
    <v-bottom-navigation>


        <v-btn @click="$router.push('/')" value="favorites">
            <v-icon> mdi-view-dashboard-outline</v-icon>

            <span v-if="smAndUp">Dashboard</span>
        </v-btn>
        <v-btn @click="$router.push('/')" value="favorites">
            <v-icon> mdi-account-group-outline</v-icon>

            <span v-if="smAndUp">Manage Team</span>
        </v-btn>
        <v-btn @click="$router.push('create-account')" value="Add Employee">
            <v-icon>mdi-account-plus-outline</v-icon>

            <span v-if="smAndUp">Add employee</span>
        </v-btn>
        <v-btn @click="$router.push('validate-time')" value="Approve Time">
            <v-icon>mdi-account-check-outline</v-icon>
            <span v-if="smAndUp">Approve Time</span>
        </v-btn>
        <v-btn @click="$router.push('profile')">
            <v-icon>mdi-account-outline</v-icon>
            <span v-if="smAndUp">Profile</span>
        </v-btn>
    </v-bottom-navigation>
</template>
