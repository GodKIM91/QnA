import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
    connected() {
      this.perform('follow', gon.params)
    },

    received(data) {
      if (gon.user != data.user_id) {
        let answerHtml = require('templates/answer.hbs')(data)
        $('.answers').append(answerHtml)
      }
    }
})