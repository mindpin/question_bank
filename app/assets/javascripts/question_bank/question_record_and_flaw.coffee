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

    # 条件查询（类型： 多选题）
    @$elm.on "click", ".result-table .question-multi", ->
      record_kind = $(this).closest(".question-multi").attr("data-kind")
      $.ajax
        url: "/question_record/#{record_kind}",
        method: "GET",
        data: {kind: record_kind},
        dataType: "json"
      .success (msg) ->
        that.set_body(msg.body)
      .error (jqXHR, textStatus) ->
        console.log("Request failed: " + textStatus)

    # 条件查询（类型： 填空题）
    @$elm.on "click", ".result-table .question-fill", ->
      record_kind = $(this).closest(".question-fill").attr("data-kind")
      $.ajax
        url: "/question_record/#{record_kind}",
        method: "GET",
        data: {kind: record_kind},
        dataType: "json"
      .success (msg) ->
        that.set_body(msg.body)
      .error (jqXHR, textStatus) ->
        console.log("Request failed: " + textStatus)

    # 条件查询（类型： 连线题）
    @$elm.on "click", ".result-table .question-mapping", ->
      record_kind = $(this).closest(".question-mapping").attr("data-kind")
      $.ajax
        url: "/question_record/#{record_kind}",
        method: "GET",
        data: {kind: record_kind},
        dataType: "json"
      .success (msg) ->
        that.set_body(msg.body)
      .error (jqXHR, textStatus) ->
        console.log("Request failed: " + textStatus)

    # 条件查询 （类型： 判断题）
    @$elm.on "click", ".result-table .question-bool", ->
      record_kind = $(this).closest(".question-bool").attr("data-kind")
      $.ajax
        url: "/question_record/#{record_kind}",
        method: "GET",
        data: {kind: record_kind},
        dataType: "json"
      .success (msg) ->
        that.set_body(msg.body)
      .error (jqXHR, textStatus) ->
        console.log("Request failed: " + textStatus)

    # 条件查询（类型：论述题）
    @$elm.on "click", ".result-table .question-essay", ->
      record_kind = $(this).closest(".question-essay").attr("data-kind")
      $.ajax
        url: "/question_record/#{record_kind}",
        method: "GET",
        data: {kind: record_kind},
        dataType: "json"
      .success (msg) ->
        that.set_body(msg.body)
      .error (jqXHR, textStatus) ->
        console.log("Request failed: " + textStatus)

    # 条件查询( 时间： 一个周内 )
    @$elm.on "click", ".result-table .question-a-week", ->
      record_kind = $(this).closest(".question-a-week").attr("data-kind")
      $.ajax
        url: "/question_record/#{record_kind}",
        method: "GET",
        data: {kind: record_kind},
        dataType: "json"
      .success (msg) ->
        that.set_body(msg.body)
      .error (jqXHR, textStatus) ->
        console.log("Request failed: " + textStatus)

    # 条件查询（时间: 一个月内）
    @$elm.on "click", ".result-table .question-a-month", ->
      record_kind = $(this).closest(".question-a-month").attr("data-kind")
      $.ajax
        url: "/question_record/#{record_kind}",
        method: "GET",
        data: {kind: record_kind},
        dataType: "json"
      .success (msg) ->
        that.set_body(msg.body)
      .error (jqXHR, textStatus) ->
        console.log("Request failed: " + textStatus) 

    # 条件查询（时间： 三个月内）
    @$elm.on "click", ".result-table .question-three-months", ->
      record_kind = $(this).closest(".question-three-months").attr("data-kind")
      $.ajax
        url: "/question_record/#{record_kind}",
        method: "GET",
        data: {kind: record_kind},
        dataType: "json"
      .success (msg) ->
        that.set_body(msg.body)
      .error (jqXHR, textStatus) ->
        console.log("Request failed: " + textStatus)

    # 条件查询（时间: 某一时段内）
    @$elm.on "click", ".result-table .question-time-fragment", ->
      record_kind = $(this).closest(".question-time-fragment").attr("data-kind")
      time_first = $("#time_first").val()
      time_second = $("#time_second").val()
      $.ajax
        url: "/question_record/#{time_first}",
        method: "GET"
        data: {kind: record_kind, second: time_second},
        dataType: "json"
      .success (msg) ->
        that.set_body(msg.body)
      .error (jqXHR, textStatus) ->
        console.log("Request failed: " + textStatus)


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