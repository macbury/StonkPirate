<template>
  <a-page-header title="Assets" sub-title="that you observe" />

  <a-menu v-model:selectedKeys="status" mode="horizontal" style="margin-bottom: 10px;">
    <a-menu-item key="READY">
      Ready
    </a-menu-item>
    <a-menu-item key="FAILED">
      Failed
    </a-menu-item>
    <a-menu-item key="INITIALIZING">
      Initializing
    </a-menu-item>
    <a-menu-item key="ARCHIVED">
      Archived
    </a-menu-item>
  </a-menu>

  <a-table bordered size="small" :scroll="{ y: 700 }" :dataSource="assets" :columns="columns" :loading="$apollo.queries.assets.loading" rowKey="id" :pagination="pagination">
    <template  plate #action="{ record }">
      <a-button ghost type="primary" @click="buy(record.id)">Buy</a-button>
    </template>
    <template #id="{ record }">
      <a-avatar :src="record.logoUrl" />
      <router-link class="ticker" :to="`/assets/${record.id}`">{{ record.id }}</router-link>
    </template>
    <template #name="{ record }">
      <a-tooltip :title="record.name">
        {{ record.name }}
      </a-tooltip>
    </template>
    <template #marketValue="{ record }">
      <a-tag class="change">{{ record.marketValue.formatted }}</a-tag>
    </template>
    <template #kind="{ record }">
      <a-tag class="change">{{ record.kind }}</a-tag>
    </template>
    <template #dailyChange="{ record }">
      <price-change :amount="record.dailyChange" class="change" />
    </template>
    <template #dailyChangePercent="{ record }">
      <percent-change :percent="record.dailyChangePercent" class="change" />
    </template>
    <template #yearChangePercent="{ record }">
      <percent-change :percent="record.yearChangePercent" class="change" />
    </template>
    <template #updatedAt="{ record }">
      {{ $date(record.updatedAt).format('DD/MM/YYYY HH:mm') }}
    </template>
  </a-table>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import PriceChange from '../components/Tags/PriceChange.vue'
import PercentChange from '../components/Tags/PercentChange.vue'
import QueryAllAssets from '../api/queries/allAssets.gql'
import { AllAssetsQuery, AssetStatusEnum } from '../api'

export default defineComponent({
  inject: ['$date', 'buy'],
  components: {
    PriceChange,
    PercentChange
  },
  data() {
    return {
      status: [AssetStatusEnum.Ready],
      assets: [],
      pagination: false,
      columns: [
        {
          title: 'Action',
          width: 100,
          key: 'action',
          slots: { customRender: 'action' },
        },
        {
          title: 'Ticker',
          key: 'id',
          dataIndex: 'id',
          slots: { customRender: 'id' },
          width: 200,
          sorter: (a, b) => a.id.localeCompare(b.id),
          defaultSortOrder: 'descend',
        },
        {
          title: 'Name',
          key: 'name',
          dataIndex: 'name',
          ellipsis: true,
          sorter: (a, b) => a.name.localeCompare(b.name),
          slots: { customRender: 'name' },
        },
        {
          title: 'Kind',
          width: 110,
          key: 'kind',
          dataIndex: 'kind',
          sorter: (a, b) => a.kind.localeCompare(b.kind),
          slots: { customRender: 'kind' },
        },
        {
          title: 'Market Value',
          width: 120,
          key: 'marketValue.amount',
          dataIndex: 'marketValue.formatted',
          slots: { customRender: 'marketValue' },
          sorter: (a, b) => a.marketValue.amount - b.marketValue.amount,
        },
        {
          title: 'Daily Change',
          width: 130,
          key: 'dailyChange.amount',
          dataIndex: 'dailyChange.formatted',
          slots: { customRender: 'dailyChange' },
          sorter: (a, b) => a.dailyChange.amount - b.dailyChange.amount,
        },
        {
          title: 'Daily Change %',
          width: 140,
          key: 'dailyChangePercent',
          dataIndex: 'dailyChangePercent',
          slots: { customRender: 'dailyChangePercent' },
          sorter: (a, b) => a.dailyChangePercent - b.dailyChangePercent,
        },
        {
          title: 'Year Change %',
          width: 140,
          key: 'yearChangePercent',
          dataIndex: 'yearChangePercent',
          slots: { customRender: 'yearChangePercent' },
          sorter: (a, b) => a.yearChangePercent - b.yearChangePercent,
        },
        {
          title: 'Last sync',
          width: 140,
          key: 'updatedAt',
          dataIndex: 'updatedAt',
          slots: { customRender: 'updatedAt' },
          sorter: (a, b) => this.$date(a.updatedAt).diff(this.$date(b.updatedAt)),
        }
      ]
    } as AllAssetsQuery
  },
  mounted() {
    this.$apollo.queries.assets.refetch()
  },
  apollo: {
    assets: {
      query: QueryAllAssets,
      variables() {
        return { status: (this as any).status[0] }
      },
      pollInterval: 60 * 1000
    }
  }
})
</script>

<style scoped>
  .ticker {
    margin-left: 10px;
  }

  .change {
    display: block;
    text-align: center;
  }

  .breadcrumb {
    margin: 16px 0;
  }
</style>