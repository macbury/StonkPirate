<template>
  <div class="header">  
    <a-page-header :title="asset.name" :sub-title="asset.id" @back="() => $router.push('/assets')">
      <template #extra>
        <a-button class="buy" type="primary" @click="buy(asset.id)">Buy</a-button>
        <a-avatar size="large" :src="asset.logoUrl" />
      </template>
    </a-page-header>
  </div>
  <a-row :gutter="16">
    <a-col :span="6">
      <price-change name="Market Value" :price="asset.marketValue" />
    </a-col>
    <a-col :span="6">
      <price-change name="Daily change" :price="asset.dailyChange" />
    </a-col>
    <a-col :span="6">
      <percent-change name="Daily change (%)" :percent="asset.dailyChangePercent" />
    </a-col>
    <a-col :span="6">
      <percent-change name="Year change (%)" :percent="asset.yearChangePercent" />
    </a-col>
  </a-row>
  <a-menu mode="horizontal" :selectable="false" class="menu">
    <a-menu-item>
      <router-link :to="`/assets/${asset.id}/`">About</router-link>
    </a-menu-item>
    <a-menu-item>
      <router-link :to="`/assets/${asset.id}/history`">History</router-link>
    </a-menu-item>
    <a-menu-item>
      <router-link :to="`/assets/${asset.id}/holdings`">Holdings</router-link>
    </a-menu-item>
    <a-menu-item>
      <router-link :to="`/assets/${asset.id}/dividends`">Dividends</router-link>
    </a-menu-item>
  </a-menu>
  <div class="tabs">
    <router-view />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import PriceChange from '../../components/Stats/PriceChange.vue'
import PercentChange from '../../components/Stats/PercentChange.vue'

export default defineComponent({
  inject: ['buy'],
  props: {
    asset: Object
  },
  components: {
    PriceChange,
    PercentChange
  },

  provide() {
    return {
      asset: this.asset
    }
  }
})
</script>

<style scoped>
  .header {
    background-color: #fff;
    margin-top: 15px;
    margin-bottom: 15px;
  }

  .buy {
    margin-right: 10px;
  }

  .menu {
    margin-top: 20px;
  }

  .tabs {
    margin-bottom: 20px;
    background-color: #fff;
    padding: 10px 25px;
  }
</style>
