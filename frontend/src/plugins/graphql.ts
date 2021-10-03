import { ApolloClient, HttpLink, InMemoryCache } from '@apollo/client/core'
import { createApolloProvider } from '@vue/apollo-option'

const apolloClient = new ApolloClient({
  link: new HttpLink({
    // You should use an absolute URL here
    uri: '/graphql',
  }),
  cache: new InMemoryCache()
})

const apolloProvider = createApolloProvider({
  defaultClient: apolloClient
})

export default apolloProvider