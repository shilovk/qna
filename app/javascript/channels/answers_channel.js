import consumer from "./consumer"
import answerHtml from "../templates/answer"

var sub_answersChannel

if (gon.question_id) {
  sub_answersChannel = consumer.subscriptions.create({
    channel: 'AnswersChannel',
    question_id: gon.question_id,
  }, {
    received(answer) {
      if (answer.user_id !== gon.user_id) {
        $('.answers').append(answerHtml(answer))
      }
    }
  })
}
else if (sub_answersChannel) sub_answersChannel.unsubscribe()
