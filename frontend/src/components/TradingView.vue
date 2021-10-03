<template>
  <div className="tradingview-widget-container" ref="containerRef">
    <div className="tradingview-widget-container__widget"></div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref } from 'vue'

export default defineComponent({
  props: {
    options: Object
  },

  setup(props) {
    const containerRef = ref<HTMLDivElement>()

    onMounted(() => {
      if (!containerRef.value) {
        return
      }

      const script = document.createElement('script');
      script.src = 'https://s3.tradingview.com/external-embedding/embed-widget-symbol-info.js'
      script.async = false;
      script.innerHTML = JSON.stringify(props.options)

      containerRef.value.appendChild(script);
    })

    return { containerRef }
  },
})
</script>
