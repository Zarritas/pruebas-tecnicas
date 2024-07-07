<template>
  <div id="app">
    <LibrosDisponibles />
<!--    <ListaDeLectura />-->
  </div>
</template>

<script>
import LibrosDisponibles from '@/components/LibrosDisponibles';
// import ListaDeLectura from '@/components/ListaDeLectura';

export default {
  name: 'App',
  components: {
    LibrosDisponibles,
    // ListaDeLectura,
  }
}
</script>

<style>
body {
  background-color: #2A2A2A;
  display: flex;
  justify-content: center;
  align-items: start;
}
#app {
  font-family: "Comic Sans MS", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: start;
  margin-top: 60px;
  width: 80vw;
  height: 100%;
  padding: 10px;
}
h1,h2,label{
  color: #AAA;
}
.completado {
  width: 100%;
  padding: 15px;
  color: green;
  border: 3px solid green;
  font-weight: bolder;
  font-size: larger;
  border-radius: 5px;
  filter: brightness(150%);
  z-index: 2;
}
</style>
