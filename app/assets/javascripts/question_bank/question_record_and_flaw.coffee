# 做题记录
class QuestionRecord
  constructor: (@$elm)->
    @bind_events()
    @$body_ele = @$elm.find(".record-body")

  set_body: (body)->
    @$body_ele.html(body)

  bind_events: ->
    that = this
    # 加入错题本
    @$elm.on "click", ".record-table .insert-flaw", ->
      $.ajax
        url: "/question_flaw",
        method: "post",
        data: {"question_record_id":  $(this).closest(".insert-flaw").attr("data-question-record-id")}
      .success (msg) ->
        window.location.reload()
      .error (msg) ->
        console.log(msg)

    # 条件查询( 结果： 正确 )
    @$elm.on "click", ".result-table .question-right", ->
      whether_correct = $(this).closest(".question-right").attr("data-whether-correct")
      record_kind = $(this).closest(".question-right").attr("data-kind")
      $.ajax
        url: "/question_record/#{whether_correct}",
        method: "GET",
        data:{kind: record_kind},
        dataType: "json"
      .done (msg) ->
        that.set_body(msg.body)
      .fail (jqXHR, textStatus)  ->
        console.log( "Request failed: " + textStatus )

    # 条件查询 （结果： 错误）
    @$elm.on "click", ".result-table .question-wrong", ->
      whether_correct = $(this).closest(".question-wrong").attr("data-whether-correct")
      record_kind = $(this).closest(".question-wrong").attr("data-kind")
      $.ajax
        url: "/question_record/#{whether_correct}",
        method: "GET",
        data: {kind: record_kind},
        dataType: "json"
      .done (msg) ->
        that.set_body(msg.body)
      .fail (jqXHR, textStatus) ->
        console.log("Request failed:" + textStatus)

    # 条件查询 ( 类型： 单选题 )
    @$elm.on "click", ".result-table .question-single", ->
      record_kind = $(this).closest(".question-single").attr("data-kind")
      $.ajax
        url: "/question_record/#{record_kind}",
        method: "GET",
        data: {kind: record_kind},
        dataType: "json"
      .success (msg) ->
        that.set_body(msg.body)
      .error (jqXHR, textStatus) ->
        console.log( "Request failed: " + textStatus )

# 错题本
class QuestionFlaw
  constructor: (@$elm)->
    @bind_events()

  bind_events: ->
    @$elm.on "click", ".flaw-table .flaw-delete", ->
      flaw_id = $(this).closest(".flaw-delete").attr("data-question-flaw-id")
      $.ajax
        url: "/question_flaw/#{flaw_id}"
        method: "DELETE"
      .success ->
        window.location.reload()
      .error ->
        console.log("error")

$(document).on 'ready page:load', ->
  if $('.question-record').length > 0 
    new QuestionRecord $('.question-record')

  if $('.question-flaw').length > 0 
    new QuestionFlaw $('.question-flaw')