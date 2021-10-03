<template>
  <a-modal
    :title="asset?.name || '...'"
    :closable="false"
    :visible="form.tickerId">

    <a-spin :spinning="spinning">
      <a-form :label-col="labelCol" :wrapper-col="wrapperCol">
        <a-form-item label="Date">
          <a-date-picker
            v-model:value="form.date"
            type="date"
            placeholder="Date"
            class="full" />
        </a-form-item>
        <a-form-item label="Shares">
          <a-input-number v-model:value="form.shares" class="full" />
        </a-form-item>
        <a-form-item label="Price per share">
          <a-input class="full" v-model:value="form.price" />
        </a-form-item>

        <a-form-item label="Commission">
          <a-input class="full" v-model:value="form.commission" :placeholder="asset?.currency?.symbol" />
        </a-form-item>
      </a-form>
    </a-spin>

    <template #footer>
      <a-spin :spinning="spinning">
        <a-button key="back" @click="handleCancel">
          Cancel
        </a-button>
        <a-button key="submit" type="primary" :loading="loading" @click="handleOk">
          Buy asset
        </a-button>
      </a-spin>
    </template>
  </a-modal>
  <slot />
</template>

<script>
import moment from 'moment';
import gql from 'graphql-tag'
import { message } from 'ant-design-vue';
import { defineComponent, provide, reactive, ref } from 'vue'

export default defineComponent({
  setup() {
    const resolve = ref(() => null)
    const form = reactive({
      tickerId: null,
      price: null,
      commission: null,
      shares: 0,
      date: moment()
    })

    const buy = (tickerId) => {
      form.tickerId = tickerId
      form.shares = 0
      form.commission = null
      form.price = null
      form.date = moment()

      return new Promise((r) => {
        resolve.value = r
      })
    }

    provide('buy', buy)

    return {
      form,
      resolve,
      labelCol: { span: 6 },
      wrapperCol: { span: 16 }
    }
  },

  data() {
    return { saving: false }
  },

  computed: {
    spinning() {
      return this.$apollo.queries.asset.loading || this.saving
    },

    input() {
      return {
        ticker: this.form.tickerId,
        date: this.form.date.format(),
        amount: parseFloat(this.form.shares), 
        price: this.form.price,
        commission: this.form.commission
      }
    }
  },

  methods: {
    async handleOk() {
      this.saving = true

      const { data: { buy: { errors } } } = await this.$apollo.mutate({
        mutation: gql`
          mutation buy($input: BuyInput!) {
            buy(input: $input) {
              holding {
                id
              }
              errors
            }
          }
        `,
        variables: { input: this.input }
      })

      this.saving = false

      if (errors.length > 0) {
        message.error(errors.join(', '))
      } else {
        message.success('Added new holding');
        this.form.tickerId = null
        this.resolve(true)
      }
    },
    handleCancel() {
      this.form.tickerId = null
      this.resolve(false)
    }
  },

  apollo: {
    asset: {
      fetchPolicy: 'network-only',
      query: gql`
        query assetMarketValue($ticker: String!, $date: ISO8601DateTime) {
          asset(ticker: $ticker) {
            id
            name
            currency {
              id
              symbol
            }
            marketValue(at: $date) {
              formatted
            }
          }
        },
      `,
      update({ asset }) {
        this.form.price = asset?.marketValue?.formatted

        return asset
      },
      skip() {
        return !this.form.tickerId
      },
      variables() {
        return {
          ticker: this.form.tickerId,
          date: this.form.date.format()
        }
      }
    }
  }
})
</script>

<style scoped>
  .full {
    width: 100%;
  }
</style>