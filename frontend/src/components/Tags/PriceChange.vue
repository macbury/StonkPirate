<template>
  <a-tag :color="color">
    <template #icon>
      <up-outlined v-if="positive" />
      <down-outlined v-else />
    </template>
    {{ amount.formatted }}
  </a-tag>
</template>

<script>
import { defineComponent } from 'vue'
import { UpOutlined, DownOutlined } from '@ant-design/icons-vue';

export default defineComponent({
  props: {
    amount: Object
  },
  components: {
    UpOutlined,
    DownOutlined
  },
  computed: {
    positive() {
      return (this.amount?.amount || 0.0) > 0.0
    },

    color() {
      return this.positive ? 'green' : 'red'
    }
  }
})
</script>
