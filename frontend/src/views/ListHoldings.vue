<template>
  <a-page-header title="Holdings" />

  <a-menu v-model:selectedKeys="state" mode="horizontal" style="margin-bottom: 10px;">
    <a-menu-item key="BUY">
      Buy
    </a-menu-item>
    <a-menu-item key="SELL">
      Sell
    </a-menu-item>
    <a-menu-item key="ARCHIVED">
      Archived
    </a-menu-item>
  </a-menu>

  <holding-table :state="state[0]" />
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import HoldingTable from '../components/Tables/HoldingTable.vue'

export default defineComponent({
  components: {
    HoldingTable
  },

  data() {
    return {
      state: ['BUY']
    }
  }
})
</script>
