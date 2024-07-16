<script>
import axios from "axios";

export default {
  name: "LibrosDisponibles",
  data() {
    return {
      listaLibrosDisponibles: null,
      listaLibrosDeLectura: new Set(),
      listaLibrosDeLecturaFiltrada: new Set(),
      pageCurrent: 0,
      maxResults: 20,
      pageMax: null,
      pageMin: 1,
      totalLibros: 0,
      idioma: null,
      urlApi: "https://www.googleapis.com/books/v1/volumes?q=",
    };
  },
  methods: {
    filtrarLibrosPorCategoria(categoria) {
      let autorFiltrado ="subject:" + categoria;
      this.buscarLibros(autorFiltrado)
    },
    filtrarLibrosPorAutor(autor) {
      let autorFiltrado ="inauthor:" + autor;
      this.buscarLibros(autorFiltrado)
    },
    buscarLibros(...args) {
      let masparametros = "";
      if (args.length > 0) {
        for (let i = 0; i < args.length; i++) {
          masparametros += "+"+args[i];
        }
        masparametros += "&"
      }
      axios.get(this.urlApi+masparametros+"language:"+this.idioma+"&startIn  dex="+(this.pageCurrent*this.maxResults)+"&maxResults="+this.maxResults)
          .then((response) => {
            this.listaLibrosDisponibles = response.data.items;
            this.totalLibros = response.data.totalItems;
            this.pageMax = Math.ceil(response.data.totalItems/20);
          }).catch((error) => {
        console.log(error);
      })
    },
    cambiarIdioma(idioma) {
      this.idioma = idioma;
      this.buscarLibros()
    },
    anterior() {
      if (this.pageCurrent > 0) {
        this.pageCurrent--;
        this.buscarLibros()
      }
    },
    siguiente() {
      if (this.pageCurrent < this.pageMax) {
        this.pageCurrent++;
        this.buscarLibros()
      }
    },
  }
};
</script>

<template>
  <div id="todo">
    <div id="librosDisponibles">
      <h1>
        {{
          this.totalLibros
        }}
        Libros Disponibles
      </h1>
      <header id="filtrarLibros" @submit.prevent>
        <div class="form-group">
          <label> Filtrar por autor </label>
          <br />
          <input
              id="autorInput"
              type="text"
              @keyup="this.filtrarLibrosPorCategoria($event.target.value)"
          />
        </div>
        <div class="form-group">
          <label> Filtrar por categoría </label>
          <br />
          <input
              id="autorInput"
              type="text"
              @keyup="this.filtrarLibrosPorAutor($event.target.value)"
          />
        </div>
        <div class="form-group">
          <label> Filtrar por idioma </label>
          <br />
          <select id="idiomaSelect" @change="this.cambiarIdioma($event.target.value)">
            <option value=""></option>
            <option value="es">Español</option>
            <option value="fr">Frances</option>
            <option value="en">Ingles</option>
          </select>
        </div>
      </header>
      <main v-if="this.idioma === null || this.idioma === ''">
        <div>
          <h1>Selecciona un idioma</h1>
        </div>
      </main>
      <main v-else>
        <div v-if="this.listaLibrosDisponibles.size === 0">
          <h1>No hay libros disponibles</h1>
        </div>
        <div v-else>
          <section
            v-for="book in this.listaLibrosDisponibles"
            :style="book.volumeInfo.imageLinks !== undefined ?
              'background: url(' +
              book.volumeInfo.imageLinks.smallThumbnail +
              ') no-repeat center center; background-size: cover;' : ''
            "
            :key="book.id"
            :id="book.id"
            :class="
              'book ' +
              (this.listaLibrosDeLectura.has(book)
                ? 'libroLectura'
                : 'libroDisponible')
            "
          >
            <div id="contenidoLibro">
              <p><span>Titulo:</span> {{ book.volumeInfo.title }}</p>
              <p><span>Nº de páginas:</span> {{ book.volumeInfo.pageCount }}</p>
              <p><span>Autor:</span> {{ book.volumeInfo.authors.join(', ') }}</p>
              <p><span>Genero:</span> {{ book.volumeInfo.categories.join(', ') }}</p>
              <p><span>Año:</span> {{ book.volumeInfo.publishedDate }}</p>
            </div>
          </section>
          <div id="paginacion">
            <button id="anterior" @click="anterior" :disabled="this.pageCurrent === 0">&ll;</button>
            <p>
              <span id="pageMinimo" v-if="this.pageCurrent !== 0">
                {{this.pageMin}} -
              </span>
              <span id="pageActual">
                {{ this.pageCurrent+1 }}
              </span>
              <span id="pageMaximo" v-if="this.pageCurrent !== this.pageMax">
                - {{ this.pageMax }}
              </span>
            </p>
            <button id="siguiente" @click="siguiente" :disabled="this.pageCurrent === this.pageMax">&gg;</button>
          </div>
        </div>
      </main>
    </div>
    <div id="listaLectura" hidden>
      <h1>Lista de lectura</h1>
      <div class="form-group">
        <label> Filtrar por nombre </label>
        <br />
        <input id="filtroPorTexto" type="text" />
      </div>
      <main>
        <div v-if="this.listaLibrosDeLecturaFiltrada.length === 0">
          <h1>No hay libros disponibles</h1>
        </div>
        <div>
          <section
            v-for="book in this.listaLibrosDeLecturaFiltrada"
            :key="book.title"
            :style="
              'background: url(' +
              book.cover +
              ') no-repeat center center; background-size: cover;'
            "
            class="book libroDisponible"
            @click="libroCompletado"
          ></section>
        </div>
      </main>
    </div>
  </div>
</template>

<style scoped>
#todo {
  display: grid;
  grid-template-columns: 2fr 1fr;
  grid-column-gap: 10px;
  width: 100%;
  height: 100%;
  align-items: start;
}

#librosDisponibles {
  width: 100%;
  height: 100%;
  padding: 10px;
  display: flex;
  flex-direction: column;
  justify-content: start;
  align-items: center;
}

#listaLectura {
  border: 1px solid #ccc;
  border-radius: 5px;
  background-color: #002;
  padding: 20px;
}

main {
  margin-bottom: 20px;
  display: flex;
  flex-wrap: wrap;
  justify-content: start;
  align-items: start;
  width: 100%;
  padding: 10px;
}

.book {
  width: 150px;
  height: 200px;
  border: 1px solid #ccc;
  border-radius: 5px;
  margin: 10px;
  float: left;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
}

img {
  width: 100%;
  height: 100%;
}

.form-group {
  margin-bottom: 10px;
}

#filtrarLibros {
  padding: 10px;
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: center;
  gap: 10px;
}

.libroLectura {
  filter: brightness(20%);
}

.libroDisponible:hover {
  transform: scale(120%);
  backdrop-filter: blur(10px);
}

#contenidoLibro {
  opacity: 0;
  width: 100%;
  height: 100%;
}

#contenidoLibro p {
  margin: 0;
  border: 1px solid #000;
  background-color: #ffffff99;
  backdrop-filter: blur(1px);
  color: red;
  font-size: small;
}

#contenidoLibro p span {
  font-weight: bold;
  color: black;
  font-size: medium;
}

#contenidoLibro:hover {
  background-color: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(5px);
  opacity: 100%;
}

.libroDisponible:hover {
  transform: scale(120%);
  backdrop-filter: blur(10px);
}

.libroDisponible:hover .description {
  display: block;
}
.libroCompletado {
  backdrop-filter: blur(1px);
  &::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(
      0,
      0,
      0,
      0.5
    );
    z-index: 1;
  }
}
#paginacion{
  display: flex;
  width: 100%;
  flex-direction: row;
  justify-content: flex-end;
  align-items: center;
  align-self: end;
  gap: 5px;
  margin-bottom: 10px;
}
#pageActual{
  color : cornflowerblue;
  font-weight: bolder;
}
</style>
