<script setup lang="ts">
import { onMounted, ref } from 'vue'
import type { Tarea } from '../types/Tarea'
import TodoItem from '../components/TodoItem.vue'

const CLAVE = 'tareas' // Clave de localStorage

const tareasDeEjemplo: Tarea[] = [
  {
    id: Math.random(),
    completado: false,
    texto: 'Mi primera tarea'
  }
]

const nuevaTarea = ref<Tarea>({ id: Math.random(), completado: false, texto: '' })

const tareas = ref<Tarea[]>([])

const editando = ref<number>(-1) // Un número negativo indica que no se edita

onMounted(() => {
  const tex = localStorage.getItem(CLAVE)
  if (tex !== null) tareas.value = JSON.parse(tex as string)
  else tareas.value = tareasDeEjemplo
})

function guardar() {
  localStorage.setItem(CLAVE, JSON.stringify(tareas.value))
}

function anadir() {
  if (nuevaTarea.value.texto !== '') {
    tareas.value.push(Object.assign({}, nuevaTarea.value))
    nuevaTarea.value.id = Math.random()
    nuevaTarea.value.texto = ''
  }
  guardar()
}

function cambiarCompletado(indice: number) {
  tareas.value[indice].completado = !tareas.value[indice].completado
  guardar()
}

function modificar(indice: number) {
  // indice = -1 para Cancelar
  editando.value = indice
}

function modificado(indice: number, tex: string) {
  tareas.value[indice].texto = tex
  guardar()
  editando.value = -1
}

function eliminar(indice: number) {
  tareas.value.splice(indice, 1)
  guardar()
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
