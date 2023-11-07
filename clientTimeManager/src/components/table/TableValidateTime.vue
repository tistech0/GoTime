<script setup lang="ts">

const stat = [
    {
        id: 1,
        username: "HGefbolij",
        start: "2023-10-25T20:48:13",
        status: "validated",
        end: "2023-10-26T05:46:13",
        valueDay: 0.0,
        valueNight: 9.0
    },
    {
        id: 2,
        username: "Ijifhqenwsdk",
        start: "2023-10-25T20:48:13",
        status: "validated",
        end: "2023-10-26T05:46:13",
        valueDay: 4.0,
        valueNight: 3.0
    },
    {
        id: 2,
        username: "Ijifhqenwsdk",
        start: "2023-10-25T20:48:13",
        status: "validated",
        end: "2023-10-26T05:46:13",
        valueDay: 4.0,
        valueNight: 3.0
    },

    {
        id: 2,
        username: "Ijifhqenwsdk",
        start: "2023-10-25T20:48:13",
        status: "validated",
        end: "2023-10-26T05:46:13",
        valueDay: 4.0,
        valueNight: 3.0
    },
    {
        id: 2,
        username: "Ijifhqenwsdk",
        start: "2023-10-25T20:48:13",
        status: "validated",
        end: "2023-10-26T05:46:13",
        valueDay: 4.0,
        valueNight: 3.0
    },
    {
        id: 2,
        username: "Ijifhqenwsdk",
        start: "2023-10-25T20:48:13",
        status: "validated",
        end: "2023-10-26T05:46:13",
        valueDay: 4.0,
        valueNight: 3.0
    },
    {
        id: 2,
        username: "Ijifhqenwsdk",
        start: "2023-10-25T20:48:13",
        status: "validated",
        end: "2023-10-26T05:46:13",
        valueDay: 4.0,
        valueNight: 3.0
    },
    {
        id: 2,
        username: "Ijifhqenwsdk",
        start: "2023-10-25T20:48:13",
        status: "validated",
        end: "2023-10-26T05:46:13",
        valueDay: 4.0,
        valueNight: 3.0
    },
    {
        id: 2,
        username: "Ijifhqenwsdk",
        start: "2023-10-25T20:48:13",
        status: "validated",
        end: "2023-10-26T05:46:13",
        valueDay: 4.0,
        valueNight: 3.0
    },
    {
        id: 2,
        username: "Ijifhqenwsdk",
        start: "2023-10-25T20:48:13",
        status: "validated",
        end: "2023-10-26T05:46:13",
        valueDay: 4.0,
        valueNight: 3.0
    },

]

// calculate sum of valueDay and valueNight for each user


</script>

<template>
    <v-table class="col-span-3 col-start-2" fixed-header height="500px">
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
            <tr v-for="item in stat" :key="item.id">
                <td>{{ item.username }}</td>
                <td>{{ item.start }}</td>
                <td>{{ item.end }}</td>
                <td>{{ item.valueDay }}</td>
                <td>{{ item.valueNight }}</td>
                <td>
                    <!-- sum valueDay and valueNight -->
                    {{
                        item.valueDay + item.valueNight

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
        </tbody>
    </v-table>
</template>