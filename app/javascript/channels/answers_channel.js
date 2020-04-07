import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  var answersList = $('.answers')

  consumer.subscriptions.create("AnswersChannel", {
    connected() {
      this.install()
    },

    install() {
      this.perform('follow', { question_id: 1 })
    },

    received(data) {
      answersList.append(data)
    }
  })
})
