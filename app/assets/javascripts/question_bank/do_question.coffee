class DoQuestion
  constructor: (@$ele)->
    @bind_submit_event()

  bind_submit_event: ->
    @$ele.on 'submit', 'form', (evt)=>
      evt.preventDefault()
      $target = jQuery evt.target
      data    = $target.serializeArray()

      jQuery.ajax
        url: $target.attr("action")
        method: "POST"
        data: data
      .success (msg) =>
        if msg["is_correct"]
          @$ele.find(".do-question-msg").text("回答正确")
        else
          @$ele.find(".do-question-msg").text("回答错误")

        setTimeout =>
          window.location.replace window.location.href
        , 500


jQuery(document).on 'ready page:load', ->
  if jQuery('.do-question-page').length > 0
    new DoQuestion jQuery('.do-question-page')
