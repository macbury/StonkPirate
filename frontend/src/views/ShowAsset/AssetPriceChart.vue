<template>
  <div ref="containerRef">
    <a-radio-group :value="currency" @change="handleCurrencyChange" class="filter">
      <a-radio-button v-for="c in currencies" :value="c.id" :key="c.id">
        {{ c.isoCode }}
      </a-radio-button>
    </a-radio-group>
    <a-spin :spinning="$apollo.queries.asset.loading">
      <UplotVue :data="history" :options="chartOptions" />
    </a-spin>
  </div>
</template>

<script>
import 'uplot/dist/uPlot.min.css'
import gql from 'graphql-tag'
import UplotVue from 'uplot-vue'
import { defineComponent, onMounted, onUnmounted, ref } from 'vue'

export default defineComponent({
  components: {
    UplotVue,
  },

  setup() {
    const containerRef = ref()
    const width = ref(0)

    const onResize = () => {
      width.value = containerRef.value?.clientWidth || 0
    }

    onMounted(() => {
      window.addEventListener('resize', onResize)
      onResize()
    })

    onUnmounted(() => window.removeEventListener('resize', onResize))

    return {
      width,
      containerRef,
    }
  },

  data() {
    return { currency: 'PLN' } //TODO: load this default currency
  },

  methods: {
    handleCurrencyChange(e) {
      this.currency = e.target.value
    }
  },

  computed: {
    tickerId() {
      return this.$route.params.tickerId
    },
    history() {
      return [
        this.asset?.history?.timestamps || [],
        this.asset?.history?.values || []
      ]
    },
    currencies() {
      return this.asset?.currencies || []
    },
    chartOptions() {
      return {
        width: this.width,
        height: 500,
        axes: [
          {},
          {
            size: 80,
            values: (self, ticks) => ticks.map(v => `${v} ${this.currency}`)
          }
        ],
        series: [
          { label: 'Date' },
          {
            label: 'Price',
            value: (self, rawValue) => `${rawValue.toFixed(2)} ${this.currency}`,
            points: {
              show: false
            },
            stroke: "#1890ff",
            fill: "#1890ff33"
          }
        ]
      }
    }
  },

  apollo: {
    asset: {
      query: gql`
        query fetchHistory($tickerId: String!, $currency: String!) {
          asset(ticker: $tickerId) {
            currencies {
              id
              isoCode
              symbol
            }

            history(currency: $currency) {
              currency {
                id
                isoCode
                symbol
              }
              values
              timestamps
            }
          }
        }
      `,

      variables() {
        return { tickerId: this.tickerId, currency: this.currency }
      }
    }
  },
})
</script>

<style scoped>
  .filter {
    margin-bottom: 10px;
  }
</style>