const getStyleRule = require('@rails/webpacker/package/utils/get_style_rule');

module.exports = getStyleRule(/\.less(\.erb)?$/i, false, [
  {
    loader: 'less-loader',
    options: {
      lessOptions: {
        strictMath: true
      },
      sourceMap: true
    }
  }
]);
