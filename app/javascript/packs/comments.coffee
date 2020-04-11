ready = ->
  $('.comments').on 'click', '.add-comment-link', (e) ->
    e.preventDefault()
    link = $(this)
    link.hide()
    link.siblings('form').show()
    link.siblings('.cancel-comment-link').show()

  $('.comments').on 'click', '.edit-comment-link', (e) ->
    e.preventDefault()
    link = $(this)
    link.hide()
    link.siblings('.view').hide()
    link.siblings('.delete-comment-link').hide()
    link.siblings('form').show()
    link.siblings('.cancel-comment-link').show()

  $('.comments').on 'click', '.cancel-comment-link', (e) ->
    e.preventDefault()
    link = $(this)
    link.hide()
    link.siblings('form').hide()
    link.siblings('.view')
    link.siblings('.add-comment-link').show()
    link.siblings('.edit-comment-link').show()
    link.siblings('.delete-comment-link').show()

$(document).on('turbolinks:load', ready);
