/* eslint-disable */
import dayjs from 'dayjs'
declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}

declare module '*.gql' {
  import { DocumentNode } from 'graphql'
  const Schema: DocumentNode

  export = Schema
}

declare module '@vue/runtime-core' {
  export interface ComponentCustomProperties {
    $date: typeof dayjs
  }
}