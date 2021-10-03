<template>
  <a-layout class="layout">
    <a-layout-header class="header">
      <div class="search">
        <slot name="search" />
      </div>
      <div class="logo" />
      <a-menu theme="dark" mode="horizontal" class="menu">
        <slot name="menu" />
      </a-menu>
    </a-layout-header>
    <a-layout-content class="content">
      <slot name="content" />
    </a-layout-content>
    <a-layout-footer class="footer">
      Stonks Pirate ©2021 Created by Arkadiusz Buras
    </a-layout-footer>
  </a-layout>
</template>

<style scoped>
  .header {
    position: fixed;
    z-index: 1;
    width: 100%;
  }

  .menu {
    line-height: 64px;
  }

  .content {
    padding: 0 50px;
    margin-top: 64px;
  }

  .footer {
    text-align: center;
  }

  .search {
    float: right;
  }
</style>