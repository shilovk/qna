import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  var questionsList = $('.questions')

  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      this.install()
    },

    install() {
      this.perform('follow')
    },

    received(data) {
      questionsList.append(data)
    }
  })
})
