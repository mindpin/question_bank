class TestPaperResult
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
        # 1 后台接到正确的params
        # 2 控制器处理
        # 3 写这个coffee
        # if msg["is_correct"]
          # @$ele.find(".do-question-msg").text("回答正确")
        # else
          # @$ele.find(".do-question-msg").text("回答错误")


jQuery(document).on 'ready page:load', ->
  if jQuery('.page-test-paper-result-new').length > 0
    new TestPaperResult jQuery('.page-test-paper-result-new')

