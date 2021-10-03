<template>
  <a-tag :color="color">
    <template #icon>
      <up-outlined v-if="positive" />
      <down-outlined v-else />
    </template>
    {{ formatted }} %
  </a-tag>
</template>

<script>
import { defineComponent } from 'vue'
import { UpOutlined, DownOutlined } from '@ant-design/icons-vue';

export default defineComponent({
  props: {
    percent: Number
  },
  components: {
    UpOutlined,
    DownOutlined
  },
  computed: {
    positive() {
      return (this.percent || 0.0) > 0.0
    },

    formatted() {
      return (this.percent * 100.0).toFixed(3)
    },

    color() {
      return this.positive ? 'green' : 'red'
    }
  }
})
</script>
