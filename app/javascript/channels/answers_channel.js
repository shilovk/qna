import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  var answersList = $('.answers')
  var sub_answersChannel

  if (gon.question_id) {
    sub_answersChannel = consumer.subscriptions.create({
      channel: 'AnswersChannel', question_id: gon.question_id
    }, {
      received(data) {
        answersList.append(data)
      }
    })
  }
  else if (sub_answersChannel) sub_answersChannel.unsubscribe()
})
