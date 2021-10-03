<template>
  <a-modal 
    okText="Watch asset"
    :closable="false"
    :width="850"
    :visible="true">
    <trading-view :options="tradingViewAsset" />

    <template #footer>
      <a-button key="back" @click="handleCancel">
        Cancel
      </a-button>
      <a-button key="submit" type="primary" :loading="loading" @click="handleOk">
        Watch this asset
      </a-button>
    </template>
  </a-modal>
</template>

<script lang="ts">
import TradingView from '../../components/TradingView.vue'
import { defineComponent } from 'vue'

export default defineComponent({
  components: {
    TradingView,
  },
  props: {
    tickerId: String,
    handleOk: Function,
  },
  methods: {
    handleCancel() {
      this.$router.go(-1)
    }
  },

  setup(props) {
    return {
      tradingViewAsset: {
        "symbol": props.tickerId,
        "width": 800,
        "locale": "en",
        "isTransparent": false
      }
    }
  }
})
</script>
