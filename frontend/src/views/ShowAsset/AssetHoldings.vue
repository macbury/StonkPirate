<template>
  <holding-table :tickerId="asset.id" />
</template>

<script>
import HoldingTable from '../../components/Tables/HoldingTable.vue'

export default {
  inject: ['asset'],

  components: {
    HoldingTable
  }
}
</script>