<template>
  <app-content>
    <h1>This is an home page</h1>
  </app-content>
</template>

<script lang="ts">
import AppContent from '../components/AppContent.vue'
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Home',
  components: {
    AppContent
  }
});
</script>
