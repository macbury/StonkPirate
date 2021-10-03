module.exports = {
  outputDir: './public/',
  assetsDir: 'packs/',
  pages: {
    index: {
      entry: './frontend/src/main.ts',
      template: './frontend/public/index.html',
      filename: 'index.html',
      title: 'Stonks Pirate'
    }
  },
  devServer: {
    proxy: {
      '^/graphql': { target: 'http://localhost:3000' },
      '^/sidekiq': { target: 'http://localhost:3000' },
      '^/uploads': { target: 'http://localhost:3000' }
    }
  }
}