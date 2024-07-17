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
      categorias: [
        "",
        "Art",
        "Biography & Autobiography",
        "Business & Economics",
        "Comics & Graphic Novels",
        "Computers",
        "Cooking",
        "Design",
        "Drama",
        "Education",
        "Family & Relationships",
        "Games",
        "Gardening",
        "Health & Fitness",
        "History",
        "Humor",
        "Law",
        "Literary Criticism",
        "Mathematics",
        "Medical",
        "Performing Arts",
        "Philosophy",
        "Poetry",
        "Political Science",
        "Psychology",
        "Religion",
        "Science",
        "Self-Help",
        "Social Science",
        "Sports & Recreation",
        "Technology & Engineering",
        "Transportation",
        "Travel",
      ],
      idiomas: ["", "es", "en", "fr"],
      idioma: null,
      urlApi: "https://www.googleapis.com/books/v1/volumes?q=",
      filters: {
        title: "",
        category: "",
        author: "",
      },
      cargando: false,
    };
  },
  methods: {
    buscarLibros() {
      this.cargando = true;
      let masparametros = [];

      if (this.filters.title)
        masparametros.push(`intitle:${this.filters.title}`);
      if (this.filters.category)
        masparametros.push(`subject:${this.filters.category}`);
      if (this.filters.author)
        masparametros.push(`inauthor:${this.filters.author}`);

      masparametros = masparametros.length ? masparametros.join("+") + "&" : "";

      axios
        .get(
          this.urlApi +
            masparametros +
            "language:" +
            this.idioma +
            "&startIndex=" +
            this.pageCurrent * this.maxResults +
            "&maxResults=" +
            this.maxResults
        )
        .then((response) => {
          if (response.data.items === null) {
            this.listaLibrosDisponibles = undefined;
            return;
          }
          this.listaLibrosDisponibles = response.data.items;
          this.totalLibros = response.data.totalItems;
          this.pageMax = Math.ceil(response.data.totalItems / 20);
        })
        .catch((error) => {
          console.log(error);
        });
      if (this.listaLibrosDisponibles === undefined) {
        this.pageCurrent = 0;
      }
      this.cargando = false;
    },
    cambiarIdioma() {
      setTimeout(this.buscarLibros, 1000);
    },
    anterior() {
      if (this.pageCurrent > 0) {
        this.pageCurrent--;
        this.buscarLibros();
      }
    },
    siguiente() {
      if (this.pageCurrent < this.pageMax) {
        this.pageCurrent++;
        this.buscarLibros();
      }
    },
  },
};
</script>

<template>
  <div id="todo">
    <div id="librosDisponibles" class="librosDisponibles flex">
      <h1>
        {{ this.totalLibros }}
        Libros Disponibles
      </h1>
      <header id="filtrarLibros" @submit.prevent>
        <div class="form-group">
          <v-text-field
            label="Filtrar por titulo"
            id="titleInput"
            v-model="filters.title"
            @blur="buscarLibros"
          />
        </div>
        <div class="form-group">
          <v-text-field
            label="Filtrar por autor"
            id="autorInput"
            v-model="filters.author"
            @blur="buscarLibros"
          />
        </div>
        <div class="form-group">
          <v-select
            id="categoriaInput"
            label="Filtrar por categoría"
            :items="categorias"
            v-model="filters.category"
            @blur="buscarLibros"
          />
        </div>
        <div class="form-group">
          <v-select
            id="idiomaSelect"
            label="Seleccionar idioma"
            :items="idiomas"
            v-model="idioma"
            @blur="cambiarIdioma"
          />
        </div>
      </header>
      <main id="cargando" v-if="cargando">
        <div class="contenedor-loader">
          <div class="rueda"></div>
        </div>
        <div class="cargando">Cargando...</div>
      </main>
      <main v-else-if="!idioma">
        <div>
          <h1>Selecciona un idioma</h1>
        </div>
      </main>
      <main v-else>
        <div
          v-if="
            this.listaLibrosDisponibles === undefined ||
            this.listaLibrosDisponibles === null ||
            this.listaLibrosDisponibles.size === 0
          "
        >
          <h1>No hay libros disponibles</h1>
        </div>
        <div v-else>
          <section
            v-for="book in this.listaLibrosDisponibles"
            :style="
              book.volumeInfo.imageLinks !== undefined
                ? 'background: url(' +
                  book.volumeInfo.imageLinks.smallThumbnail +
                  ') no-repeat center center; background-size: cover;'
                : ''
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
              <p class="description" v-if="book.volumeInfo.title !== undefined">
                <span>Titulo:</span> {{ book.volumeInfo.title }}
              </p>
              <p
                class="description"
                v-if="book.volumeInfo.pageCount !== undefined"
              >
                <span>Nº de páginas:</span> {{ book.volumeInfo.pageCount }}
              </p>
              <p
                class="description"
                v-if="book.volumeInfo.authors !== undefined"
              >
                <span>Autor:</span> {{ book.volumeInfo.authors.join(", ") }}
              </p>
              <p
                class="description"
                v-if="book.volumeInfo.categories !== undefined"
              >
                <span>Genero:</span> {{ book.volumeInfo.categories.join(", ") }}
              </p>
              <p
                class="description"
                v-if="book.volumeInfo.publishedDate !== undefined"
              >
                <span>Año:</span> {{ book.volumeInfo.publishedDate }}
              </p>
            </div>
          </section>
        </div>
        <div id="paginacion">
          <button
            id="anterior"
            @click="anterior"
            :disabled="this.pageCurrent === 0"
          >
            &ll;
          </button>
          <p>
            <span id="pageMinimo" v-if="this.pageCurrent !== 0">
              {{ this.pageMin }} -
            </span>
            <span id="pageActual">
              {{ this.pageCurrent + 1 }}
            </span>
            <span id="pageMaximo" v-if="this.pageCurrent + 1 !== this.pageMax">
              - {{ this.pageMax }}
            </span>
          </p>
          <button
            id="siguiente"
            @click="siguiente"
            :disabled="this.pageCurrent === this.pageMax - 1"
          >
            &gg;
          </button>
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
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}

.librosDisponibles {
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
  width: 400px;
}

.v-text-field input {
  min-width: 400px;
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
    background: rgba(0, 0, 0, 0.5);
    z-index: 1;
  }
}

#paginacion {
  display: flex;
  width: 100%;
  flex-direction: row;
  justify-content: flex-end;
  align-items: center;
  align-self: end;
  gap: 5px;
  margin-bottom: 10px;
  color: #cccccc;
}

#pageActual {
  color: cornflowerblue;
  font-weight: bolder;
}

.description {
  max-height: 20%;
  margin: 0;
  overflow: auto;
  padding-left: 5px;
}

.rueda {
  border: 10px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-left-color: transparent;
  width: 80px;
  height: 80px;
  animation: giro 1s linear infinite;
}

@keyframes giro {
  0% {
    transform: rotate(0deg);
  }

  100% {
    transform: rotate(360deg);
  }
}

.cargando {
  position: relative;
  color: #fff;
  margin-top: 2em;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

#cargando {
  display: grid;
  place-content: center;
  height: 100vh;
  color: #000;
}
</style>
