<template>
  <a-button @click="$router.push(to)"><slot /></a-button>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  props: {
    to: String
  }
})
</script>
