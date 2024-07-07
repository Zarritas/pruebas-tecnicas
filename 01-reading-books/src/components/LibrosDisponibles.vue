<script>
// import {genero, libros} from '@/store/store';
// import FiltrarLibros from '@/components/FiltrarLibros';
import lista from "@/assets/books.json";

export default {
  name: "LibrosDisponibles",
  /*components: {
    FiltrarLibros,
  },*/
  data() {
    return {
      listaLibrosDisponibles: new Set(),
      listaLibrosDisponiblesFiltrada: new Set(),
      listaLibrosDeLectura: new Set(),
      listaLibrosDeLecturaFiltrada: new Set(),
      listaGeneros: null,
      pageMin: null,
      pageMax: null,
    };
  },
  methods: {
    agregarLibroALectura(libro) {
      this.listaLibrosDeLectura.add(libro);
      this.listaLibrosDeLecturaFiltrada.add(libro);
      document.getElementById(libro.title).classList.add("libroLectura");
      document.getElementById(libro.title).classList.remove("libroDisponible");
      document.getElementById(libro.title).firstChild.hidden = true;
      if (this.listaLibrosDeLectura.size > 0) {
        document.getElementById("listaLectura").hidden = false;
      }
    },
    quitarLibroDeLectura(libro) {
      this.listaLibrosDeLectura.delete(libro);
      this.listaLibrosDeLecturaFiltrada.delete(libro);
      document.getElementById(libro.title).classList.remove("libroLectura");
      document.getElementById(libro.title).classList.add("libroDisponible");
      document.getElementById(libro.title).firstChild.hidden = false;
      if (this.listaLibrosDeLectura.size === 0) {
        document.getElementById("listaLectura").hidden = true;
      }
    },
  },
  beforeMount() {
    this.listaLibrosDisponibles = JSON.parse(JSON.stringify(lista));
    this.listaLibrosDisponiblesFiltrada = new Set(
      this.listaLibrosDisponibles.library
    );
    this.listaGeneros = new Set(
      this.listaLibrosDisponibles.library.map((book) => book.book.genre)
    );
    this.pageMin = Math.min(
      ...this.listaLibrosDisponibles.library.map((book) => book.book.pages)
    );
    this.pageMax = Math.max(
      ...this.listaLibrosDisponibles.library.map((book) => book.book.pages)
    );
  },
  mounted() {
    document
      .getElementById("generoSelect")
      .addEventListener("change", (event) => {
        if (event.target.value === "") {
          this.listaLibrosDisponiblesFiltrada = new Set(
            this.listaLibrosDisponibles.library
          );
        } else if (this.listaGeneros.has(event.target.value)) {
          let aux = this.listaLibrosDisponibles.library.slice();
          this.listaLibrosDisponiblesFiltrada = aux.filter(
            (book) => book.book.genre === event.target.value
          );
        }
      });
    document.getElementById("pageRange").addEventListener("input", (event) => {
      if (
        this.pageMin <= event.target.value &&
        this.pageMax >= event.target.value
      ) {
        let aux = this.listaLibrosDisponibles.library.slice();
        this.listaLibrosDisponiblesFiltrada = aux.filter(
          (book) => book.book.pages >= event.target.value
        );
      }
    });
    document
      .getElementById("filtroPorTexto")
      .addEventListener("keyup", (event) => {
        let aux = new Set(this.listaLibrosDeLectura);
        this.listaLibrosDeLecturaFiltrada = new Set(Array.from(aux).filter((book) =>
          book.title.startsWith(event.target.value.charAt(0).toUpperCase() + event.target.value.slice(1))
        ));
      });
  },
};
</script>

<template>
  <div id="todo">
    <div id="librosDisponibles">
      <h1>
        {{
          this.listaLibrosDisponibles.library.length -
          this.listaLibrosDeLectura.size
        }}
        Libros Disponibles
      </h1>
      <h2>{{ this.listaLibrosDeLectura.size }} en lista de lectura</h2>
      <div id="filtrarLibros">
        <div class="form-group">
          <label> Filtrar por Nº de páginas </label>
          <br />
          <input
            id="pageRange"
            type="range"
            step="1"
            :max="this.pageMax"
            :min="this.pageMin"
          />
        </div>
        <div class="form-group">
          <label> Filtrar por genero </label>
          <br />
          <select id="generoSelect">
            <option value=""></option>
            <option v-for="genre in this.listaGeneros" :key="genre">
              {{ genre }}
            </option>
          </select>
        </div>
      </div>
      <main>
        <div v-if="listaLibrosDisponiblesFiltrada.size === 0">
          <h1>No hay libros disponibles</h1>
        </div>
        <div v-else>
          <section
            v-for="book in this.listaLibrosDisponiblesFiltrada"
            :style="
              'background: url(' +
              book.book.cover +
              ') no-repeat center center; background-size: cover;'
            "
            :key="book.book.title"
            :id="book.book.title"
            :class="
              'book ' +
              (this.listaLibrosDeLectura.has(book.book)
                ? 'libroLectura'
                : 'libroDisponible')
            "
            @click="agregarLibroALectura(book.book)"
          >
            <div id="contenidoLibro">
              <p><span>Titulo:</span> {{ book.book.title }}</p>
              <p><span>Nº de páginas:</span> {{ book.book.pages }}</p>
              <p><span>Autor:</span> {{ book.book.author.name }}</p>
              <p><span>Genero:</span> {{ book.book.genre }}</p>
              <p><span>Año:</span> {{ book.book.year }}</p>
            </div>
          </section>
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
            class="book libroDisponible"
            @click="quitarLibroDeLectura(book)"
          >
            <img :src="book.cover" :id="book.title" :alt="book.title" />
          </section>
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
}

#librosDisponibles {
  width: 100%;
  height: 100%;
  padding: 10px;
  display: flex;
  flex-direction: column;
  justify-content: center;
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
</style>
