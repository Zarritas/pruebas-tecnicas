<template>
  <v-app>
    <v-main>
      <LibrosDisponibles />
    </v-main>
  </v-app>
</template>

<script>
import LibrosDisponibles from "@/components/LibrosDisponibles.vue";

export default {
  name: "App",

  components: {
    LibrosDisponibles,
  },

  data: () => ({
    //
  }),
};
</script>
<style>
.v-main{
  background-color: #23242b;
  color: #cccccc;
  display: flex;
  justify-content: center;
  align-items: center;
}
.LibrosDisponibles{
  background-color: #23242b;
  color: #cccccc;
  width: 80%;
}
</style>