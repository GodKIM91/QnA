const { environment } = require('@rails/webpacker')

const webpack = require("webpack")
const handlebars = require('./loaders/handlebars')

environment.plugins.append("Provide", new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']  // Not a typo, we're still using popper.js here
}))

environment.loaders.prepend('handlebars', handlebars)

module.exports = environment 