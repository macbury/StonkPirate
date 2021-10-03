<template>
  <router-link :to="to" custom v-slot="{ href, navigate, isActive }">
    <li class="ant-menu-overflow-item ant-menu-item ant-menu-item-only-child" :class="[isActive ? 'ant-menu-item-selected' : null]">
      <div class="anticon anticon-mail ant-menu-item-icon">
        <slot name="icon" />
      </div>
      <a class="ant-menu-title-content" :href="href" @click="navigate">
        <slot />
      </a>
    </li>
  </router-link>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  props: {
    to: String
  }
})
</script>
