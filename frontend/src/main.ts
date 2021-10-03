import 'ant-design-vue/dist/antd.css'
import './main.css'
import dayjs from 'dayjs';
import { createApp } from 'vue'
import Antd from 'ant-design-vue'
import App from './App.vue'
import graphql from './plugins/graphql'
import './registerServiceWorker'
import router from './router'

const app = createApp(App)
  .use(router)
  .use(graphql)
  .use(Antd)
  .provide('$date', dayjs)

app.mount('#app')
