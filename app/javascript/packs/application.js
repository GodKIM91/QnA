// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// add jquery
require('jquery')
require("packs/answers")
require("packs/questions")
import $ from 'jquery'
window.jQuery = $
window.$ = $

Rails.start()
Turbolinks.start()
ActiveStorage.start()
