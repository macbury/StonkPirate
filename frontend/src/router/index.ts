import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue')
  },
  {
    path: '/assets',
    component: () => import('../views/Assets.vue')
  },
  {
    path: '/assets/:tickerId',
    props: true,
    component: () => import('../views/ShowAsset.vue'),
    children: [
      { path: '', component: () => import('../views/ShowAsset/AssetAbout.vue'), props: true },
      { path: 'history', component: () => import('../views/ShowAsset/AssetPriceChart.vue'), props: true },
      { path: 'holdings', component: () => import('../views/ShowAsset/AssetHoldings.vue'), props: true }
    ]
  },
  {
    path: '/holdings',
    name: 'Holdings',
    component: () => import('../views/ListHoldings.vue')
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
