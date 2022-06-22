<script setup lang="ts">
import { onMounted, ref } from 'vue'
import axios from 'axios'
import type { Tarea } from '../types/Tarea'
import TodoItem from '../components/TodoItem.vue'

const APIURL = 'http://todo2.varelacastelo.com/api/tareas'

const nuevaTarea = ref<Tarea>({ id: '', completado: false, texto: '' })

const tareas = ref<Tarea[]>([])

const editando = ref<number>(-1) // Un número negativo indica que no se edita

onMounted(() => {
  axios.get(APIURL).then(function (response: { data: Tarea[] }) {
    tareas.value = response.data
  })
})

function anadir() {
  if (nuevaTarea.value.texto !== '') {
    const tarea = Object.assign({}, nuevaTarea.value)
    axios.post(APIURL, tarea).then(function (response: { data: Tarea }) {
      tareas.value.push(response.data)
    })
    nuevaTarea.value.id = ''
    nuevaTarea.value.texto = ''
  }
}

function cambiarCompletado(indice: number) {
  const tarea = Object.assign({}, tareas.value[indice])
  tarea.completado = !tarea.completado
  axios.put(APIURL + '?id=' + tarea.id, tarea).then(function () {
    tareas.value[indice].completado = !tareas.value[indice].completado
  })
}

function modificar(indice: number) {
  // indice = -1 para Cancelar
  editando.value = indice
}

function modificado(indice: number, tex: string) {
  const tarea = Object.assign({}, tareas.value[indice])
  tarea.texto = tex
  axios.put(APIURL + '?id=' + tarea.id, tarea).then(function () {
    tareas.value[indice].texto = tex
    editando.value = -1
  })
}

function eliminar(indice: number) {
  const tarea = Object.assign({}, tareas.value[indice])
  axios.delete(APIURL + '?id=' + tarea.id).then(function () {
    tareas.value.splice(indice, 1)
  })
}
</script>

<template>
  <div class="ms-3">
    <h1>Aplicación ToDo</h1>
    <form @submit.prevent="anadir()" class="mb-3">
      <div class="mb-3">
        <label for="nuevaTarea" class="form-label">Nueva tarea:</label>
        <input
          v-model="nuevaTarea.texto"
          name="nuevaTarea"
          autocomplete="off"
          class="form-control w-50"
        />
      </div>
      <button type="submit" class="btn btn-primary">Añadir tarea</button>
    </form>
    <h3 v-if="tareas.length > 0">Lista de tareas</h3>
    <h3 v-else>Sin tareas</h3>
    <div class="container-fluid">
      <div v-for="(tarea, indice) in tareas" :key="tarea.id" class="row">
        <TodoItem
          :indice="indice"
          :editando="editando"
          :completado="tarea.completado"
          :texto="tarea.texto"
          @eliminar="eliminar"
          @modificar="modificar"
          @modificado="modificado"
          @completar="cambiarCompletado"
        />
      </div>
    </div>
  </div>
</template>
