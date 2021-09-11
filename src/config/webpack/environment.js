const { environment } = require('@rails/webpacker')

// jQueryの導入
const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    Popper: 'popper.js'
  })
)

module.exports = environment

// https://qiita.com/kazutosato/items/d47b7705ee545de4cb1a