<template>
  <a-modal
    :title="holding?.asset?.name || '...'"
    :closable="false"
    :visible="form.holdingId">

    <a-spin :spinning="spinning">
      <a-form :label-col="labelCol" :wrapper-col="wrapperCol">
        <a-form-item label="Sell Date">
          <a-date-picker
            v-model:value="form.date"
            type="date"
            placeholder="Date"
            style="width: 100%" />
        </a-form-item>
        <a-form-item label="Shares">
          <a-input-number v-model:value="form.shares" :min="1" :max="holding?.amount" style="width: 100%" />
        </a-form-item>
        <a-form-item label="Price per share">
          <a-input style="width: 100%" v-model:value="form.price" />
        </a-form-item>

        <a-form-item label="Commission">
          <a-input style="width: 100%" v-model:value="form.commission" :placeholder="holding?.asset?.currency?.symbol" />
        </a-form-item>
      </a-form>
    </a-spin>

    <template #footer>
      <a-spin :spinning="spinning">
        <a-button key="back" @click="handleCancel">
          Cancel
        </a-button>
        <a-button key="submit" type="primary" :loading="loading" @click="handleOk">
          Sell holding
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
      holdingId: null,
      price: null,
      commission: null,
      shares: 0,
      date: moment()
    })

    const sell = (holdingId) => {
      form.holdingId = holdingId
      form.shares = 1
      form.commission = null
      form.price = null
      form.date = moment()

      return new Promise((r) => {
        resolve.value = r
      })
    }

    provide('sell', sell)

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
      return this.$apollo.queries.holding.loading || this.saving
    },

    input() {
      return {
        id: this.form.holdingId,
        closeDate: this.form.date.format(),
        amount: parseFloat(this.form.shares), 
        closePrice: this.form.price,
        closeCommission: this.form.commission
      }
    }
  },

  methods: {
    async handleOk() {
      this.saving = true

      const { data: { sell: { errors } } } = await this.$apollo.mutate({
        mutation: gql`
          mutation sell($input: SellInput!) {
            sell(input: $input) {
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
        message.success('Sold holding');
        this.form.holdingId = null
        this.resolve(true)
      }
    },
    handleCancel() {
      this.form.holdingId = null
      this.resolve(false)
    }
  },

  apollo: {
    holding: {
      fetchPolicy: 'network-only',
      query: gql`
        query findHolding($id : ID!, $date: ISO8601DateTime){
          holding(id: $id) {
            amount
            
            asset {
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
          }
        }
      `,
      update({ holding }) {
        this.form.price = holding?.asset?.marketValue?.formatted

        return holding
      },
      skip() {
        return !this.form.holdingId
      },
      variables() {
        return {
          id: this.form.holdingId,
          date: this.form.date.format()
        }
      }
    }
  }
})
</script>
