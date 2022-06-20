<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <header>
    <nav class="nav">
      <a class="nav-link">
        <RouterLink :to="'/'">Inicio</RouterLink>
      </a>
      <a class="nav-link">
        <RouterLink :to="'/todo'">Aplicación ToDo</RouterLink>
      </a>
      <a class="nav-link" href="https://github.com/gonzalo-varelarua/ToDoSWS" target="_blank">
        GitHub
      </a>
    </nav>
  </header>

  <RouterView />
</template>
