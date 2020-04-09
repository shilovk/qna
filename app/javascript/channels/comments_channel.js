import consumer from "./consumer"
import commentHtml   from "../templates/comment"

var sub_commmentsChannel

if (gon.question_id) {
  sub_commmentsChannel = consumer.subscriptions.create({
    channel: 'CommentsChannel',
    question_id: gon.question_id,
  }, {
    received(data) {
      var action = data.action
      var comment = data.comment

      if (comment.user_id !== gon.user_id) {
        var resourceType = comment.commentable_type.toLowerCase()
        var resourceId = comment.commentable_id
        var resource = $(`#${resourceType}-${resourceId}`)
        var commentsList = resource.find('.comments .list')

        if (action == 'create') { commentsList.append(commentHtml(comment)); return }
        if (action == 'update') { commentsList.find(`#comment-${comment.id}`).html(commentHtml(comment)); return }
        if (action == 'destroy') { commentsList.find(`#comment-${comment.id}`).remove(); return }
      }
    }
  })
}
else if (sub_commentsChannel) sub_commentsChannel.unsubscribe()
