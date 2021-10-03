<template>
  <a-result v-if="$apollo.queries.asset.loading" title="Loading..." />
  <a-result v-else-if="initializing" title="Please wait, Initializing asset..." />
  <asset-details v-else-if="ready" :asset="asset" />
  <new-asset v-else :tickerId="tickerId" :handleOk="watchAsset" />
</template>

<script lang="ts">
import { message } from 'ant-design-vue'
import { defineComponent } from 'vue'
import { AssetStatusEnum, Asset } from '../api'
import FIND_ASSET from '../api/queries/findAsset.gql'
import OBSERVE_ASSET from '../api/mutations/observe.gql'
import AssetDetails from './ShowAsset/AssetDetails.vue'
import NewAsset from './ShowAsset/NewAsset.vue'

export interface IShowAssetData {
  asset: Asset
}

export interface IShowAssetProps {
  tickerId: string
}

export default defineComponent<IShowAssetProps, IShowAssetData, IShowAssetProps>({
  components: { NewAsset, AssetDetails },

  computed: {
    initializing() {
      return this.asset?.status === AssetStatusEnum.Initializing
    },

    ready() {
      return this.asset?.status === AssetStatusEnum.Ready
    },

    tickerId() {
      return this.$route.params.tickerId
    }
  },

  methods: {
    async watchAsset() {
      await this.$apollo.mutate({
        mutation: OBSERVE_ASSET,
        variables: { ticker: this.tickerId }
      })

      await this.$apollo.queries.asset.refetch()
      message.success(`Watching new asset: ${this.tickerId}`)
    }
  },

  apollo: {
    asset: {
      query: FIND_ASSET,
      variables() {
        return {
          tickerId: this.tickerId
        }
      },
      pollInterval: 10000,
      skip() {
        return !this.tickerId
      }
    }
  }
})
</script>
