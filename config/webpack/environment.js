const {environment} = require('@rails/webpacker');

const {graphql, less, moduleLess} = require('./loaders');

environment.loaders.append('graphql', graphql);
environment.loaders.append('less', less);
environment.loaders.append('less.module', moduleLess);

module.exports = environment;

// Added due to issues with @rails/actioncable being transpiled by babel-loader
// https://github.com/rails/webpacker/blob/master/docs/v4-upgrade.md#excluding-node_modules-from-being-transpiled-by-babel-loader
// https://github.com/rails/rails/issues/35501#issuecomment-555312633
const nodeModulesLoader = environment.loaders.get('nodeModules');
if (!Array.isArray(nodeModulesLoader.exclude)) {
  nodeModulesLoader.exclude =
    nodeModulesLoader.exclude === null ? [] : [nodeModulesLoader.exclude];
}

nodeModulesLoader.exclude.push(/@rails\/actioncable/);
