<template>
  <a-table bordered size="small" :scroll="{ y: 700 }" :dataSource="holdings" :columns="columns" :loading="loading" rowKey="id" :pagination="false">
    <template #id="{ record }">
      {{ record.id }}
    </template>
    <template #ticker="{ record }">
      {{ record.asset.id }}
    </template>
    <template #name="{ record }">
      <a-avatar :src="record.asset.logoUrl" class="logo" />
      <router-link :to="`/assets/${record.asset.id}/holdings`">{{ record.asset.name }}</router-link>
    </template>
    <template #openDate="{ record }">
      {{ $date(record.openDate).format('DD/MM/YYYY') }}
    </template>
    <template #netGain="{ record }">
      <price-change :amount="record.netGain.exchange" class="change" />
    </template>
    <template #dailyChange="{ record }">
      <price-change :amount="record.dailyChange.exchange" class="change" />
    </template>
    <template #dailyChangePercent="{ record }">
      <percent-change :percent="record.dailyChangePercent" class="change" />
    </template>
    <template #netGainPercent="{ record }">
      <percent-change :percent="record.netGainPercent" class="change" />
    </template>
    <template #action="{ record }">
      <a-button class="action" v-if="record.state === 'BUY'" ghost type="primary" @click="performSell(record.id)">Sell</a-button>
      <a-popconfirm v-if="record.state !== 'ARCHIVED'" placement="right" title="Are you sure archive this holding?" @confirm="performArchive(record.id)">
        <a-button class="action"  ghost type="danger">Archive</a-button>
      </a-popconfirm>
    </template>
  </a-table>
</template>

<script>
import gql from 'graphql-tag'
import { message } from 'ant-design-vue';
import PriceChange from '../Tags/PriceChange.vue'
import PercentChange from '../Tags/PercentChange.vue'
import ALL_HOLDINGS_QUERY from '../../api/queries/allHoldings.gql'
import { HoldingStateEnum } from '../../api'

export default {
  inject: ['$date', 'sell'],

  components: {
    PriceChange,
    PercentChange
  },

  props: {
    tickerId: String,
    state: String
  },

  methods: {
    async performSell(holdingId) {
      if (await this.sell(holdingId)) {
        await this.$apollo.queries.holdings.refetch()
      }
    },

    async performArchive(holdingId) {
      const { data: { archiveHolding: { errors } } } = await this.$apollo.mutate({
        mutation: gql`
          mutation archiveHolding($input: ArchiveInput!) {
            archiveHolding(input: $input) {
              errors
            }
          }
        `,
        variables: { input: { id: holdingId } }
      })

      if (errors.length > 0) {
        message.error(errors.join(', '))
      } else {
        message.success('Archived holding');
      }
      await this.$apollo.queries.holdings.refetch()
    }
  },

  apollo: {
    holdings: {
      query: ALL_HOLDINGS_QUERY,
      pollInterval: 60 * 1000,
      fetchPolicy: 'cache-and-network',
      variables() {
        return {
          state: this.state || HoldingStateEnum.Buy,
          ticker: this.tickerId
        }
      }
    }
  },

  computed: {
    loading() {
      return this.$apollo.queries.holdings.loading
    }
  },

  data() {
    return {
      columns: [
        {
          title: 'Action',
          width: 170,
          key: 'action',
          slots: { customRender: 'action' },
        },
        {
          title: 'Id',
          key: 'id',
          dataIndex: 'id',
          slots: { customRender: 'id' },
          width: 60,
          sorter: (a, b) => a.id - b.id,
          defaultSortOrder: 'descend',
        },
        {
          title: 'Ticker',
          key: 'ticker',
          width: 150,
          dataIndex: 'asset.id',
          sorter: (a, b) => a.asset.id.localeCompare(b.asset.id),
          slots: { customRender: 'ticker' },
        },
        {
          title: 'Name',
          key: 'name',
          dataIndex: 'name.id',
          ellipsis: true,
          sorter: (a, b) => a.asset.name.localeCompare(b.asset.name),
          slots: { customRender: 'name' },
        },
        // {
        //   title: 'State',
        //   key: 'state',
        //   width: 100,
        //   dataIndex: 'state',
        //   sorter: (a, b) => a.state.localeCompare(b.state),
        // },
        {
          title: 'Open Date',
          width: 120,
          key: 'openDate',
          dataIndex: 'openDate',
          slots: { customRender: 'openDate' },
          sorter: (a, b) => this.$date(a.openDate).diff(this.$date(b.openDate)),
        },
        {
          title: 'Amount',
          width: 100,
          key: 'amount',
          dataIndex: 'amount',
          sorter: (a, b) => a.amount - b.amount,
        },
        {
          title: 'Open Value',
          width: 120,
          key: 'openValue.amount',
          dataIndex: 'openValue.formatted',
          sorter: (a, b) => a.openValue.amount - b.openValue.amount
        },
        {
          title: 'Market Value',
          width: 120,
          key: 'marketValue.amount',
          dataIndex: 'marketValue.formatted',
          sorter: (a, b) => a.marketValue.amount - b.marketValue.amount
        },
        {
          title: 'Net Gain',
          width: 140,
          key: 'netGain.exchange.amount',
          dataIndex: 'netGain.exchange.amount',
          sorter: (a, b) => a.netGain.exchange.amount - b.netGain.exchange.amount,
          slots: { customRender: 'netGain' },
        },
        {
          title: 'Net Gain (%)',
          width: 140,
          key: 'dailyChangePercent',
          dataIndex: 'dailyChangePercent',
          sorter: (a, b) => a.netGainPercent - b.netGainPercent,
          slots: { customRender: 'netGainPercent' },
        },
        {
          title: 'Daily Change',
          width: 140,
          key: 'dailyChange.exchange.amount',
          dataIndex: 'dailyChange.exchange.amount',
          sorter: (a, b) => a.dailyChange.exchange.amount - b.dailyChange.exchange.amount,
          slots: { customRender: 'dailyChange' },
        },
        {
          title: 'Daily Change %',
          width: 140,
          key: 'dailyChangePercent',
          dataIndex: 'dailyChangePercent',
          sorter: (a, b) => a.dailyChangePercent - b.dailyChangePercent,
          slots: { customRender: 'dailyChangePercent' },
        }
      ]
    }
  }
}
</script>

<style scoped>
  .logo {
    margin-right: 10px;
  }

  .change {
    display: block;
    text-align: center;
  }

  .action {
    margin-right: 8px;
  }
</style>