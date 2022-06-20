<script setup lang="ts">
import { ref } from 'vue'

const props = defineProps<{
  indice: number
  editando: number
  completado: boolean
  texto: string
}>()

// editando === indice --> Modo edición
// editando < 0        --> Sin edición. Posible Eliminar

defineEmits<{
  (e: 'completar', id: number): void
  (e: 'eliminar', id: number): void
  (e: 'modificar', id: number): void
  (e: 'modificado', id: number, tex: string): void
}>()

const completadoEdit = ref<boolean>(props.completado)
const textoEdit = ref<string>(props.texto)

const strModal = ref('')
const muestraModal = ref(false)

function openModal(str: string) {
  strModal.value = str
  muestraModal.value = true
}

function closeModal() {
  muestraModal.value = false
}
</script>

<template>
  <div class="col-1">
    <input
      type="checkbox"
      v-model="completadoEdit"
      @click="$emit('completar', indice)"
      class="form-check-input"
    />
  </div>
  <div class="col">
    <label v-if="editando < 0" @dblclick="$emit('modificar', indice)">{{ textoEdit }}</label>
    <label v-else-if="editando !== indice">{{ textoEdit }}</label>
    <input
      v-else
      v-model="textoEdit"
      @keyup.enter="$emit('modificado', indice, textoEdit)"
      @keyup.escape="
        textoEdit = texto
        $emit('modificar', -1)
      "
      @vnode-mounted="({ el }: any) => el.focus()"
      class="form-control"
    />
  </div>
  <div class="col-6 col-md-4 col-lg-3 col-xl-2">
    <button v-if="editando < 0" @click="$emit('modificar', indice)" class="btn btn-link me-1">
      Modificar
    </button>
    <button
      v-else-if="editando === indice"
      @click="
        textoEdit = texto
        $emit('modificar', -1)
      "
      class="btn btn-link me-1"
    >
      Cancelar
    </button>
    <button
      v-if="editando === indice"
      @click="$emit('modificado', indice, textoEdit)"
      class="btn btn-link"
    >
      Guardar
    </button>
    <button v-if="editando < 0" @click="openModal(texto)" class="btn btn-link">Eliminar</button>
  </div>
  <Modal v-model="muestraModal" :close="closeModal">
    <div class="modal">
      <p v-html="strModal"></p>
      <button
        type="button"
        @click="
          $emit('eliminar', indice)
          closeModal
        "
        class="btn btn-danger me-3"
      >
        eliminar
      </button>
      <button type="button" @click="closeModal" class="btn btn-outline-dark">cancelar</button>
    </div>
  </Modal>
</template>

<style scoped>
.modal {
  display: block;
  position: relative;
  height: auto;
  width: 310px;
  padding: 30px;
  box-sizing: border-box;
  background-color: #fff;
  font-size: 20px;
  text-align: center;
}
</style>
