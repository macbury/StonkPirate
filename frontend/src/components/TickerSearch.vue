<template>
  <a-auto-complete
    :dataSource="search"
    class="certain-category-search"
    dropdown-class-name="certain-category-search-dropdown"
    v-model:value="ticker"
    size="large"
    placeholder="Ticker name"
    @select="goToTicker"
    style="width: 400px">
    <template #dataSource>
      <a-select-option v-for="searchResult in search" :key="searchResult.ticker.id">
        {{ searchResult.ticker.id }} - {{ searchResult.description }}
      </a-select-option>
    </template>
  </a-auto-complete>
</template>

<script>
import gql from 'graphql-tag'
import { defineComponent } from 'vue'

export default defineComponent({
  methods: {
    goToTicker(value) {
      this.$router.push(`/assets/${value}`)
    }
  },
  data() {
    return { ticker: '' } 
  },
  apollo: {
    search: {
      query: gql`
        query search($query: String!) {
          search(ticker: $query) {
            ticker {
              id
            }
            description
          }
        }
      `,
      variables() {
        return { query: this.ticker }
      }
    }
  }
})
</script>
