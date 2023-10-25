<template>
  <div>
    <div class="currentWeather-wrapper">
      <h1>Météo actuelle</h1>
      <div class="search-wrapper">
        <label for="city">Sélectionnez une ville :</label>
        <select id="city" v-model="selectedCity" class="selectorTown">
          <option v-for="city in cities" :key="city.id" :value="city.id">
            {{ city.name }}
          </option>
        </select>
        <button @click="fetchWeatherData">Mettre à jour</button>
      </div>
      <div class="meteo-wrapper">
        <p>Température : {{ temperature }}°C</p>
        <p>Date : {{ date }}</p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import axios from "axios";

export default {
    data() {
      return {
        selectedCity: this.$route.params.city,
        cities: [
          { name: "Paris", id: 2988507 },
          { name: "Lyon", id: 2996944 },
          { name: "Marseille", id: 2995469 },
          { name: "Bordeaux", id: 3031582 },
          { name: "Lille", id: 2998324 },
          { name: "Nantes", id: 2990969}
        ],
        temperature: null,
        date: null
      };
    },
    mounted() {
      // Faites une requête à l'API météo ici et mettez à jour les données.
      this.fetchWeatherData();
    },
    methods: {
      async fetchWeatherData() {
       try {
        const apiKey = 'a6ea88f4a6af6f3cf8c2b8b9ab8b8b54'
        const response = await axios.get(`https://api.openweathermap.org/data/2.5/weather?id=${this.selectedCity}&appid=${apiKey}&units=metric&lang=fr`);
        console.log(response.data);
        this.temperature = response.data.main.temp;
        this.date = new Date(response.data.dt * 1000).toLocaleDateString();

       } catch (error) {
            console.error('Error import API meteo',error);
       }
      }
    }
  };
</script>

<style scoped>
.currentWeather-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 1000px;
  border-radius: 10px;
}
.selectorTown {
  width: 200px;
  height: 30px;
  border-radius: 10px;
  margin-bottom: 20px;
}
.search-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 1000px;
  background-color: darkgrey;
  border-radius: 10px;
  margin-bottom: 20px;
  padding: 20px;
}
.meteo-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 1000px;
  background-color: darkgrey;
  border-radius: 10px;
  padding: 20px;
}
</style>
