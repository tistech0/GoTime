<template>
    <div class="col-span-5 mt-10 ml-20">
        <p>Hello <span>{{ user.username }}</span>,</p>
    </div>
</template>

<script lang="ts">
import { useUserStore } from "@/stores/user";

export default {
    data() {
        const user = useUserStore().getUser;

        return {
            user: user,
        }
    }
}
</script>

<style scoped>
span {
    color: var(--secondary-pink);
}
</style>