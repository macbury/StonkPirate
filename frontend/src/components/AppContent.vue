<template>
  <a-breadcrumb class="breadcrumb">
    <a-breadcrumb-item>Home</a-breadcrumb-item>
  </a-breadcrumb>
  <div class="inner-content">
    <slot/>
  </div>
</template>

<style scoped>
  .breadcrumb {
    margin: 16px 0;
  }
  
  .inner-content {
    background: #fff;
    padding: 24px;
    min-height: 280px;
  }
</style>