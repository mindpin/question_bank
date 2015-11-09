class QuestionRecord
  constructor: (@$elm)->
    @bind_events()

  bind_events: ->
    @$elm.on "click", ".record-table .insert-flaw", ->
      $.ajax
        url: "/question_flaw",
        method: "post",
        data: {"question_record_id":  $(this).closest(".insert-flaw").attr("data-question-record-id")},
        dataType: "json"
      .success (msg) ->
        console.log(msg)
      .error (msg) ->
        console.log(msg)

$(document).on 'ready page:load', ->
  if $('.question-record').length > 0 
    new QuestionRecord $('.question-record')
