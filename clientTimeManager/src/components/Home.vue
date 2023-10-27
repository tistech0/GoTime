<script setup lang="ts">
import { reactive } from 'vue';
import type { Role } from '../types/roles';

const thing = reactive<{ roles: Role[] }>({ roles: [] });

async function getData() {
    const res = await fetch("http://localhost:4000/api/roles");
    const { data } = await res.json();
    console.log(data);
    thing.roles = data;
}
getData();
</script>
<template>
    <div class="greetings">
        <h3>
            We are going to test things
        </h3>
        <table>
            <tr>
                <th>ROLES:</th>
                <!-- get all roles -->
                <th>
                    {{
                        thing.roles.map(role => role.role).join(" - ")
                    }}
                </th>
            </tr>
        </table>
    </div>
</template>

<style scoped>
h1 {
    font-weight: 500;
    font-size: 2.6rem;
    position: relative;
    top: -10px;
}

h3 {
    font-size: 1.2rem;
}

.greetings h1,
.greetings h3 {
    text-align: center;
}

@media (min-width: 1024px) {

    .greetings h1,
    .greetings h3 {
        text-align: left;
    }
}
</style>
