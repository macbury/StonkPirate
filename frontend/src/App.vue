<template>
  <app-layout>
    <template #menu>
      <header-link to="/">
        <template #icon>
          <HomeOutlined class="icon" />
        </template>
        Home
      </header-link>
      <header-link to="/assets">
        <template #icon>
          <DollarCircleOutlined class="icon" />
        </template>
        Assets
      </header-link>
      <header-link to="/holdings">
        <template #icon>
          <ShoppingCartOutlined class="icon" />
        </template>
        Holdings
      </header-link>
      <header-link to="/dividends">
        <template #icon>
          <MoneyCollectOutlined class="icon" />
        </template>
        Dividends
      </header-link>
    </template>
    <template #search>
      <ticker-search />
    </template>
    <template #content>
      <buy>
        <sell>
          <router-view/>
        </sell>
      </buy>
    </template>
  </app-layout>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

import Sell from './components/Dialogs/Sell.vue'
import Buy from './components/Dialogs/Buy.vue'
import TickerSearch from './components/TickerSearch.vue'
import AppLayout from './components/AppLayout.vue'
import HeaderLink from './components/HeaderLink.vue'
import { HomeOutlined, DollarCircleOutlined, ShoppingCartOutlined, MoneyCollectOutlined } from '@ant-design/icons-vue'

export default defineComponent({
  components: {
    MoneyCollectOutlined,
    HomeOutlined,
    DollarCircleOutlined,
    ShoppingCartOutlined,
    TickerSearch,
    AppLayout,
    HeaderLink,
    Buy,
    Sell
  },
})
</script>

<style scoped>
  .icon {
    font-size: 20px;
    margin-right: 5px;
  }
</style>