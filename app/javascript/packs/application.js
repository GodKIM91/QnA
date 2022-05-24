// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import gistLoader from "easy-gist-async"

// add jquery
require('jquery')
require("@nathanvda/cocoon")
require("packs/answers")
require("packs/questions")
require("packs/rank")
import $ from 'jquery'
window.jQuery = $
window.$ = $

// load gist content instead of link
document.addEventListener('turbolinks:load', function () {
    gistLoader()
})
document.addEventListener('ajax:success', function () {
    gistLoader()
})

Rails.start()
Turbolinks.start()
ActiveStorage.start()
