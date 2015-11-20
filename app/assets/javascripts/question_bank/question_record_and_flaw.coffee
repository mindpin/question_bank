# 做题记录
class QuestionRecord
  constructor: (@$elm)->
    @bind_events()
    @$body_ele = @$elm.find(".record-tbody")

  set_body: (body)->
    @$body_ele.html(body)

  set_ajax: (record_kind,other_one,other_two)->
    if other_one == undefined
      record_url = record_kind
    else
      record_url = other_one
    jQuery.ajax
      url: "/question_record/#{record_url}",
      method: "GET",
      data: {kind: record_kind, second: other_two},
      dataType: "json"
    .success (msg) =>
      @set_body(msg.body)
    .error (msg) =>
      console.log( msg )

  set_delete_ajax: (id)->
    if confirm("确认删除吗？")
      if id.length == 24
        $.ajax
          url: "/question_record/#{id}",
          method: "DELETE",
          dataType: "json"
        .success (msg) =>
          @set_body(msg.body)
        .error (msg) =>
          console.log(msg)
      else
        $.ajax
          url: "/question_record/#{id}",
          method: "DELETE",
          data: {checked_ids: id}
          dataType: "json"
        .success (msg) =>
          @set_body(msg.body)
        .error (msg) =>
          console.log(msg)
    else
      console.log("已取消删除")

  bind_events: ->
    that = this
    # 加入错题本
    @$elm.on "click", ".record-table .insert-flaw", ->
      jQuery.ajax
        url: "/question_flaw",
        method: "post",
        data: {question_record_id:  jQuery(this).closest(".insert-flaw").attr("data-question-record-id")}
      .success (msg) ->
        window.location.reload()
      .error (msg) ->
        console.log(msg)

    # 删除做题记录
    @$elm.on "click", ".record-table .record-tbody .delete-record", ->
      record_id = $(this).closest(".delete-record").attr("data-question-record-id")
      that.set_delete_ajax(record_id)
        

    # 条件查询( 结果： 正确 )
    @$elm.on "click", ".result-table .question-right", ->
      whether_correct = jQuery(this).closest(".question-right").attr("data-whether-correct")
      record_kind = jQuery(this).closest(".question-right").attr("data-kind")
      that.set_ajax(record_kind,whether_correct)

    # 条件查询 （结果： 错误）
    @$elm.on "click", ".result-table .question-wrong", ->
      whether_correct = jQuery(this).closest(".question-wrong").attr("data-whether-correct")
      record_kind = jQuery(this).closest(".question-wrong").attr("data-kind")
      that.set_ajax(record_kind,whether_correct)

    # 条件查询 ( 类型： 单选题 )
    @$elm.on "click", ".result-table .question-single", ->
      record_kind = jQuery(this).closest(".question-single").attr("data-kind")
      that.set_ajax(record_kind)

    # 条件查询（类型： 多选题）
    @$elm.on "click", ".result-table .question-multi", ->
      record_kind = jQuery(this).closest(".question-multi").attr("data-kind")
      that.set_ajax(record_kind)

    # 条件查询（类型： 填空题）
    @$elm.on "click", ".result-table .question-fill", ->
      record_kind = jQuery(this).closest(".question-fill").attr("data-kind")
      that.set_ajax(record_kind)

    # 条件查询（类型： 连线题）
    @$elm.on "click", ".result-table .question-mapping", ->
      record_kind = jQuery(this).closest(".question-mapping").attr("data-kind")
      that.set_ajax(record_kind)

    # 条件查询 （类型： 判断题）
    @$elm.on "click", ".result-table .question-bool", ->
      record_kind = jQuery(this).closest(".question-bool").attr("data-kind")
      that.set_ajax(record_kind)

    # 条件查询（类型：论述题）
    @$elm.on "click", ".result-table .question-essay", ->
      record_kind = jQuery(this).closest(".question-essay").attr("data-kind")
      that.set_ajax(record_kind)

    # 条件查询( 时间： 一个周内 )
    @$elm.on "click", ".result-table .question-a-week", ->
      record_kind = jQuery(this).closest(".question-a-week").attr("data-kind")
      that.set_ajax(record_kind)

    # 条件查询（时间: 一个月内）
    @$elm.on "click", ".result-table .question-a-month", ->
      record_kind = jQuery(this).closest(".question-a-month").attr("data-kind")
      that.set_ajax(record_kind)

    # 条件查询（时间： 三个月内）
    @$elm.on "click", ".result-table .question-three-months", ->
      record_kind = jQuery(this).closest(".question-three-months").attr("data-kind")
      that.set_ajax(record_kind)

    # 条件查询（时间: 某一时段内）
    @$elm.on "click", ".result-table .question-time-fragment", ->
      record_kind = jQuery(this).closest(".question-time-fragment").attr("data-kind")
      time_first = jQuery("#time_first").val()
      time_second = jQuery("#time_second").val()
      that.set_ajax(record_kind,time_first,time_second)

    # 全选
    @$elm.on "click", ".record-table .record-thead .th-record-check .flaw-checked-all", ->
      jQuery('.flaw-checked-all').change( ->
        checkboxes = jQuery(this).closest('.record-table').find(':checkbox')
        if jQuery(this).is(':checked') 
          checkboxes.prop('checked', true)
        else
          checkboxes.prop('checked', false)
      )

    # 批量加入错题本
    @$elm.on "click", ".record-bottom .batch-into-flaw", ->
      checkedValues = $('input:checkbox:checked').map( ->
        this.value
      ).get()
      if checkedValues.length == 0
        alert("请选择条目")
      else
        $.ajax
          url: "/question_flaw",
          method: "POST",
          data: {question_record_id:  checkedValues, whether_batch:"batch_operation"},
        .success (msg) ->
          window.location.reload()
        .error (msg) ->
          console.log(msg)

    # 批量删除
    @$elm.on "click", ".record-bottom .batch-delete-record", ->
      checkedValues = $('input:checkbox:checked').map( ->
        this.value
      ).get()
      if checkedValues.length == 0
        alert("请选择条目")
      else
        that.set_delete_ajax(checkedValues)

# 错题本
class QuestionFlaw
  constructor: (@$elm)->
    @bind_events()
    @$body_ele = @$elm.find(".flaw_tbody")

  set_body: (body)->
    @$body_ele.html(body)

  set_ajax: (flaw_kind,other_one,other_two)->
    if other_one == undefined
      flaw_url = flaw_kind
    else
      flaw_url = other_one
    $.ajax
      url: "/question_flaw/#{flaw_url}",
      method: "GET",
      data: {kind: flaw_kind, second: other_two},
      dataType: "json"
    .success (msg) =>
      @set_body(msg.body)
    .error (msg) =>
      console.log(msg)

  set_delete_ajax: (id)->
    if confirm("确认删除吗？")
      if id.length == 24
        jQuery.ajax
          url: "/question_flaw/#{id}"
          method: "DELETE"
          dataType: "json"
        .success (msg) =>
          @set_body(msg.body)
        .error (msg) =>
          console.log(msg)
      else
        jQuery.ajax
          url: "/question_flaw/#{id}"
          method: "DELETE"
          data: {checked_ids: id}
          dataType: "json"
        .success (msg) =>
          @set_body(msg.body)
        .error (msg) =>
          console.log(msg)
    else
      console.log("已取消删除")


  bind_events: ->
    that = this
    # 删除记录
    @$elm.on "click", ".flaw-table .flaw-delete", ->
      flaw_id = jQuery(this).closest(".flaw-delete").attr("data-question-flaw-id")
      that.set_delete_ajax(flaw_id)

    # 条件查询（类型：单选题）
    @$elm.on "click", ".result-table .question-flaw-single", ->
      flaw_kind = jQuery(this).closest(".question-flaw-single").attr("data-kind")
      that.set_ajax(flaw_kind)

    # 条件查询（类型：多选题）
    @$elm.on "click", ".result-table .question-flaw-multi", ->
      flaw_kind = jQuery(this).closest(".question-flaw-multi").attr("data-kind")
      that.set_ajax(flaw_kind)

    # 条件查询（类型: 填空题）
    @$elm.on "click", ".result-table .question-flaw-fill", ->
      flaw_kind = jQuery(this).closest(".question-flaw-fill").attr("data-kind")
      that.set_ajax(flaw_kind)

    # 条件查询（类型: 连线题）
    @$elm.on "click", ".result-table .question-flaw-mapping", ->
      flaw_kind = jQuery(this).closest(".question-flaw-mapping").attr("data-kind")
      that.set_ajax(flaw_kind)

    # 条件查询（类型: 判断题）
    @$elm.on "click", ".result-table .question-flaw-bool", ->
      flaw_kind = jQuery(this).closest(".question-flaw-bool").attr("data-kind")
      that.set_ajax(flaw_kind)

    # 条件查询（类型: 论述题）
    @$elm.on "click", ".result-table .question-flaw-essay", ->
      flaw_kind = jQuery(this).closest(".question-flaw-essay").attr("data-kind")
      that.set_ajax(flaw_kind)

    # 条件查询（时间: 一周内）
    @$elm.on "click", ".result-table .flaw-in-aweek", ->
      flaw_kind = jQuery(this).closest(".flaw-in-aweek").attr("data-kind")
      that.set_ajax(flaw_kind)

    # 条件查询（时间: 一个月内）
    @$elm.on "click", ".result-table .flaw-in-amonth", ->
      flaw_kind = jQuery(this).closest(".flaw-in-amonth").attr("data-kind")
      that.set_ajax(flaw_kind)

    # 条件查询（时间: 一个月内）
    @$elm.on "click", ".result-table .flaw-three-month", ->
      flaw_kind = jQuery(this).closest(".flaw-three-month").attr("data-kind")
      that.set_ajax(flaw_kind)

    # 条件查询（时间: 某一时段内）
    @$elm.on "click", ".result-table .flaw-time-fragment", ->
      flaw_kind = jQuery(this).closest(".flaw-time-fragment").attr("data-kind")
      time_first = jQuery("#time_first").val()
      time_second = jQuery("#time_second").val()
      that.set_ajax(flaw_kind,time_first,time_second)

    # 全选
    @$elm.on "click", ".flaw-table .flaw_thead .th_record_check .flaw-checked-all", ->
      jQuery('.flaw-checked-all').change( ->
        checkboxes = jQuery(this).closest('.flaw-table').find(':checkbox')
        if jQuery(this).is(':checked') 
          checkboxes.prop('checked', true)
        else
          checkboxes.prop('checked', false)
      )

    # 批量删除
    @$elm.on "click", ".flaw-bottom .batch-delete-flaw", -> 
      checkedValues = jQuery('input:checkbox:checked').map( ->
        this.value
      ).get()
      if checkedValues.length == 0
        alert("请选择条目")
      else
        that.set_delete_ajax(checkedValues)

jQuery(document).on 'ready page:load', ->
  if jQuery('.question-record').length > 0 
    new QuestionRecord jQuery('.question-record')

  if jQuery('.question-flaw').length > 0 
    new QuestionFlaw jQuery('.question-flaw')