import consumer from "./consumer"
import answerHtml from "../templates/answer"

$(document).on('turbolinks:load', function(){
  var answersList = $('.answers')
  var sub_answersChannel

  if (gon.question_id) {
    sub_answersChannel = consumer.subscriptions.create({
      channel: 'AnswersChannel',
      question_id: gon.question_id,
    }, {
      received(answer) {
        if (gon.user_id !== answer.user_id) {
          answersList.append(answerHtml(answer))
        }
      }
    })
  }
  else if (sub_answersChannel) sub_answersChannel.unsubscribe()
})
