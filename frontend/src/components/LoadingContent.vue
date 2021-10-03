<template>
  <div class="loading-container">
    <a-spin size="large" />
  </div>
</template>

<style scoped>
  .loading-container {
    flex: 1;
    flex-direction: row;
    align-content: center;
    justify-items: center;
  }

  .loading-container > .ant-spin {
    position: initial;
    display: block;
    margin-top: 80px;
    margin-bottom: 80px;
  }
</style>