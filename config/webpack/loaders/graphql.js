module.exports = {
  test: /\.(?<id>graphql|gql)$/,
  exclude: /node_modules/,
  loader: 'graphql-tag/loader'
};
