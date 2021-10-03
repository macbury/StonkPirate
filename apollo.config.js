module.exports = {
  client: {
    service: {
      name: 'stonks',
      // URL to the GraphQL API
      url: 'http://localhost:3000/graphql',
    },
    // Files processed by the extension
    includes: [
      './frontend/src/**/*.gql',
      './frontend/src/**/*.vue',
      './frontend/src/**/*.js',
      './frontend/src/**/*.ts',
    ],
    excludes: [
      './node_modules'
    ]
  },
}