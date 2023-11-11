<script setup lang="ts">

import { ref } from 'vue';
import type { TableStats } from '@/types/tableStats.ts';
import { useDisplay } from 'vuetify';
import SelectOne from '../form/SelectOne.vue';
import type { Item } from "@/types/items";
import { errorHandling } from "@/utils/utils";
import { useSnackbarStore } from '@/stores/snackbar';
import { useRoute } from 'vue-router';

const snackbarStore = useSnackbarStore();
const router = useRoute();
const { mobile } = useDisplay()
const apiUrl = import.meta.env.VITE_API_URL;




let workingTimesList = ref<TableStats[]>([]);
const listTeam = ref<Item[]>([]);
console.log(listTeam);


const queryUuid = ref<any>(router.params.id);
const queryStartTime = ref<string>("2021-11-08 10:01:56");
const queryEndTime = ref<string>("2025-11-08 10:01:56");


////////////////TEAM///////////////////


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




/**
 *  This function fetchs the list of working times from the api who are waiting for validation for a specific team in a year, a manager can only see the working times of his team
 */

// TODO: a manager can only see the working times of his team
const fetchData = async () => {
    console.log("THIS IS A FETCH" + queryUuid.value);

    try {
        const response = await fetch(`${apiUrl}/api/stats/team/workingtimes/all/${queryUuid.value}?start=${queryStartTime.value}&end=${queryEndTime.value}`,
            {
                method: "GET",
                credentials: "include",
                headers: {
                    'Content-Type': 'application/json'
                }
            });
        const data = await response.json();

        const waitingWorkingTimes = data.data.filter((item: { status: string }) => item.status === 'waiting');

        workingTimesList.value = waitingWorkingTimes.map(
            (w: any) => ({ // TODO: create interface to replace any
                ...w,
                start: new Date(w.start),
                end: new Date(w.end),
                valueDay: parseInt(w.valueDay),
                valueNight: parseInt(w.valueNight),
            })
        );

        console.log(workingTimesList.value);
    } catch (error) {
        console.error(error);

    }
};

if (queryUuid.value) {
    fetchData();
}
// fetch the data needed for the validate time table


</script>

<template>
    <SelectOne class="w-60 text-xs col-start-2 mt-20" label="Pick team" :itemList=listTeam hint="Pick a team"
        v-model="queryUuid" @update:modelValue="fetchData()" :clearable=false />


    <v-table :class="{ dwm: mobile }" class="col-span-3 col-start-2" fixed-header height="500px">
        <thead class="drop-shadow-md">
            <tr>
                <th class="text-left">
                    Name
                </th>
                <template v-if=mobile>
                    <th class="text-left">
                        Time
                    </th>
                </template>
                <template v-else>
                    <th class="text-left">
                        Start
                    </th>
                    <th class="text-left">
                        End
                    </th>
                    <th class="text-left">
                        Day
                    </th>
                    <th class="text-left">
                        Night
                    </th>
                    <th class="text-left">
                        Total
                    </th>
                </template>
                <th class="text-left">
                    Operation
                </th>
            </tr>
        </thead>
        <tbody>
            <template v-if="workingTimesList.length === 0">
                <tr>
                    <td colspan="7" class="text-center">
                        Select a team to have access to the working times
                    </td>
                </tr>
            </template>
            <template v-else>
                <tr v-for="item in workingTimesList" :key="item.id">
                    <td>
                        {{ item.user.username }}
                    </td>
                    <template v-if=mobile>
                        <td>
                            {{
                                item.start.toLocaleString("en", {
                                    month: "short",
                                    day: "numeric",
                                    hour: "numeric",
                                    minute: "numeric",
                                    year: "numeric",
                                })
                            }}
                            <br />
                            {{
                                item.end.toLocaleString("en", {
                                    month: "short",
                                    day: "numeric",
                                    hour: "numeric",
                                    minute: "numeric",
                                    year: "numeric",
                                })
                            }}
                        </td>
                    </template>
                    <template v-else>
                        <td>
                            {{
                                item.start.toLocaleString("en", {
                                    month: "short",
                                    day: "numeric",
                                    hour: "numeric",
                                    minute: "numeric",
                                    year: "numeric",
                                })
                            }}
                        </td>
                        <td>
                            {{
                                item.end.toLocaleString("en", {
                                    month: "short",
                                    day: "numeric",
                                    hour: "numeric",
                                    minute: "numeric",
                                    year: "numeric",
                                })
                            }}
                        </td>
                        <td>{{ (Math.round(item.valueDay * 100) / 100).toFixed(2) }} h</td>
                        <td>{{ (Math.round(item.valueNight * 100) / 100).toFixed(2) }} h</td>
                        <td>
                            <!-- sum valueDay and valueNight -->
                            {{
                                (Math.round((item.valueDay + item.valueNight) * 100) / 100).toFixed(2)

                            }}
                        </td>
                    </template>
                    <td>
                        <v-icon class="mr-2">
                            mdi-check
                        </v-icon>
                        <v-icon class="mr-2">
                            mdi-close
                        </v-icon>
                    </td>
                </tr>
            </template>
        </tbody>
    </v-table>
</template>

<style scoped>
.dwm {
    @apply col-span-6 m-2;
}
</style>