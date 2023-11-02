<script lang="ts" setup>
import { useDisplay } from 'vuetify';

const { smAndUp } = useDisplay()
</script>

<template>
    <v-bottom-navigation>
        <v-btn value="recent">
            <v-icon>mdi-home-outline</v-icon>

            <span v-if="smAndUp">Home</span>
        </v-btn>

        <v-btn value="favorites">
            <v-icon>mdi-view-dashboard-outline</v-icon>

            <span v-if="smAndUp">Dashboard</span>
        </v-btn>

        <v-btn value="nearby">
            <v-icon>mdi-account-plus-outline</v-icon>

            <span v-if="smAndUp">Add employee</span>
        </v-btn>
        <v-btn>
            <v-icon>mdi-account-outline</v-icon>
            <span v-if="smAndUp">Profile</span>
        </v-btn>
    </v-bottom-navigation>
</template>
