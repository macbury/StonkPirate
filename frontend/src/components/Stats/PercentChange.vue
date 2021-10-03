<template>
  <a-card>
    <a-statistic
      :title="name"
      :value="`${formatted} %`"
      :precision="2"
      :value-style="valueStyle">
      <template #prefix>
        <arrow-up-outlined v-if="isRaising" />
        <arrow-down-outlined v-else />
      </template>
    </a-statistic>
  </a-card>
</template>

<script>
import { defineComponent } from 'vue'
import { ArrowUpOutlined, ArrowDownOutlined } from '@ant-design/icons-vue'

export default defineComponent({
  props: {
    percent: Object,
    name: String,
  },

  components: {
    ArrowUpOutlined,
    ArrowDownOutlined,
  },

  computed: {
    isRaising() {
      return this.percent > 0
    },

    formatted() {
      return (this.percent * 100.0).toFixed(3)
    },

    valueStyle() {
      if (this.isRaising) {
        return { color: '#3f8600' }
      } else {
        return { color: '#cf1322' }
      }
    }
  }
})
</script>
