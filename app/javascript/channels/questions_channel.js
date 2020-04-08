import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  var questionsList = $('.questions')
  var sub_questionsChannel

  if (questionsList.length) {
    sub_questionsChannel = consumer.subscriptions.create('QuestionsChannel', {
      received(data) {
        questionsList.append(data)
      }
    })
  }
  else if (sub_questionsChannel) sub_questionsChannel.unsubscribe()
})
