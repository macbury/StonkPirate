<template>
  <div v-if="asset">
    <p>{{ asset.description || '-' }}</p>
    <a-descriptions bordered>
      <a-descriptions-item label="Ticker">{{ asset.id }}</a-descriptions-item>
      <a-descriptions-item label="Currency">{{ asset.currency.id }}</a-descriptions-item>
      <a-descriptions-item label="Country">{{ asset.country?.name || '-' }}</a-descriptions-item>

      <a-descriptions-item label="Status" :span="2">
        <a-badge status="processing" :text="asset.status" />
      </a-descriptions-item>
      <a-descriptions-item label="Updated at">{{ asset.updatedAt }}</a-descriptions-item>

      <a-descriptions-item label="PE">N/A</a-descriptions-item>
      <a-descriptions-item label="Dividends">N/A</a-descriptions-item>
      <a-descriptions-item label="Price Book">N/A</a-descriptions-item>
      
    </a-descriptions>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  inject: ['asset']
})
</script>
