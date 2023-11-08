<script setup lang="ts">

import { ref } from 'vue';
import type { TableStats } from '../../types/tableStats.ts';


let workingTimesList = ref<TableStats[]>([]);


const fetchData = async () => {
    try {
        const response = await fetch('http://localhost:4000/api/stats/team/workingtimes/all/1?start=2022-10-25 20:48:13&end=2025-10-25 20:48:37',
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
fetchData();

</script>

<template>
    <v-table class="col-span-3 col-start-2 mt-10" fixed-header height="500px">
        <thead class="drop-shadow-md">
            <tr>
                <th class="text-left">
                    Name
                </th>
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
                <th class="text-left">
                    Operation
                </th>
            </tr>
        </thead>
        <tbody>
            <template v-if="workingTimesList.length === 0">
                <tr>
                    <td colspan="7" class="text-center">
                        No data available
                    </td>
                </tr>
            </template>
            <template v-else>
                <tr v-for="item in workingTimesList" :key="item.id">
                    <td>
                        <!-- {{ item.user.username }} -->
                        MACHIN CHOSE
                    </td>
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