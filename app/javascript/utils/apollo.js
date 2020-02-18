import {ApolloLink} from 'apollo-link';
import {ApolloClient} from 'apollo-client';
import {ApolloProvider} from 'react-apollo';
import {HttpLink} from 'apollo-link-http';
import {InMemoryCache} from 'apollo-cache-inmemory';
import ActionCable from 'actioncable';
import ActionCableLink from 'graphql-ruby-client/subscriptions/ActionCableLink';

const cable = ActionCable.createConsumer();

const httpLink = new HttpLink({
  uri: '/graphql',
  credentials: 'include'
});

const hasSubscriptionOperation = ({query: {definitions}}) => {
  return definitions.some(
    ({kind, operation}) =>
      kind === 'OperationDefinition' && operation === 'subscription'
  );
};

const link = ApolloLink.split(
  hasSubscriptionOperation,
  new ActionCableLink({cable}),
  httpLink
);

const client = new ApolloClient({
  link,
  cache: new InMemoryCache()
});
