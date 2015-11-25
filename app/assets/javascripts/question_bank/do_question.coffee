class DoQuestion
  constructor: (@$elm)->
    @bind_events()

  get_question_id: ()->
    @$elm.find('.question-id').attr('data-id')

  answer_right_effect: ()->
    @$elm.find(".glyphicon-remove").addClass('hidden')
    @$elm.find(" .next a").removeClass('hidden');
    @$elm.find(" .do-question-msg p").text('回答正确')
    @$elm.find(" .do-question-msg p").css("color",'green')

  # answer_isnt_correct
  write_wrong_information: (kind,wrong_msg)->
    @$elm.find(" .next a").addClass('hidden');
    @$elm.find(" .do-question-msg p").css("color",'red')
    switch kind
      when "fill"
        @$elm.find('.do-question-msg p').text(wrong_msg)
      when "single_choice"
        @$elm.find('.do-question-msg p').text(wrong_msg)
      when "bool"
        @$elm.find('.do-question-msg p').text(wrong_msg)
      when "mapping"
        @$elm.find('.do-question-msg p').html(wrong_msg)
      when "multi_choice"
        @$elm.find('.do-question-msg p').html(wrong_msg)

  bool_validation: (bool_answer)=>
    id = @get_question_id()
    $.ajax
        url: "/questions/do_question_validation",
        method: "post",
        data: {
          answer :bool_answer,
          answer_id:id,
          kind : 'bool'
        }
      .success (msg) =>
        information = msg['information']
        if information.length == 0
          @answer_right_effect()
        else
          wrong_information_mod = "正确答案："
          if information[0] == true
            wrong_information_mod += "正确"
          else
            wrong_information_mod += "错误"
          @$elm.find('.question-bool input:checked').closest('.option').find('.glyphicon-remove').removeClass('hidden')
          @write_wrong_information('bool',wrong_information_mod)

  fill_validation: (fill_question_array)=>
    id = @get_question_id()
    $.ajax
        url: "/questions/do_question_validation",
        method: "post",
        data: {
          answer :fill_question_array,
          answer_id:id,
          kind : 'fill'
        }
      .success (msg) =>
        information = msg['information']
        if information.length == 0
          @answer_right_effect()
        else
          wrong_information_mod = "正确答案："
          for x in [0..information.length-1]
            wrong_information_mod += information[x]['right_answer']+" "
            index = information[x]['index']
            @$elm.find(".question-fill:eq(#{index})").find('.glyphicon-remove').removeClass('hidden')
          @write_wrong_information('fill',wrong_information_mod)

  single_choice_validation: (checked_option)=>
    id = @get_question_id()
    $.ajax
        url: "/questions/do_question_validation",
        method: "post",
        data: {
          answer :checked_option,
          answer_id:id,
          kind : 'single_choice'
        }
      .success (msg) =>
        information = msg['information'][0]
        if information == undefined
          @answer_right_effect()
        else
          @$elm.find('.option-radio input:checked').closest('.option').find('.glyphicon-remove').removeClass('hidden')
          wrong_information_mod = '正确答案：'+information[0]
          @write_wrong_information('single_choice',wrong_information_mod)

  multi_choice_validation: (answer_array)=>
    id = @get_question_id()
    $.ajax
        url: "/questions/do_question_validation",
        method: "post",
        data: {
          answer :answer_array,
          answer_id:id,
          kind : 'multi_choice'
        }
      .success (msg) =>
        information = msg['information']
        if information.length == 0
          @answer_right_effect()
        else
          wrong_information_mod = "正确选项："+'</br>'
          for x in [0..msg['checked_option'].length-1]
            wrong_information_mod += msg['checked_option'][x][0]+"</br>"
          for x in [0..information.length-1]
            @$elm.find(".option-checkbox:eq(#{information[x].index})").closest('.option').find('.option-content span').removeClass('hidden')
          @write_wrong_information('multi_choice',wrong_information_mod)

  mapping_validation: (answer_array)=>
    id = @get_question_id()
    $.ajax
        url: "/questions/do_question_validation",
        method: "post",
        data: {
          answer :answer_array,
          answer_id:id,
          kind : 'mapping'
        }
      .success (msg) =>
        information = msg['information']
        wrong_information_mod = "正确选项："+'</br>'
        if msg['information'].length == 0
          @answer_right_effect()
        else
          for x in [0..msg['information'].length-1]
            @$elm.find(".mapping-pair:eq(#{information[x].index})").find('.glyphicon-remove').removeClass('hidden')
          for x in [0..msg['right_option'].length-1]
            wrong_information_mod += msg['right_option'][x][0]+'-----'+msg['right_option'][x][1]+'</br>'
          @write_wrong_information('mapping',wrong_information_mod)

  essay_without_validation: (filled_content)=>
    id = @get_question_id()
    $.ajax
        url: "/questions/do_question_validation",
        method: "post",
        data: {
          answer :filled_content,
          answer_id:id,
          kind : 'essay'
        }
      .success (msg) =>
        @answer_right_effect()

  bind_events: ->
    @$elm.find('.mapping-pair .select').change (event)=>
      changed_option = $(event.target).find('option:selected').text()
      if @before_click == '空'&&changed_option != '空'
        $(event.target).closest('.question-mapping-list').find("option[value =#{changed_option}]").addClass('hidden')
        $(event.target).find("option[value =#{changed_option}]").removeClass('hidden')
      if @before_click != '空'&&changed_option != @before_click
        $(event.target).closest('.question-mapping-list').find("option[value =#{@before_click}]").removeClass('hidden')
    @$elm.find('.mapping-pair .select').click (event)=>
      @before_click = $(event.target).find('option:selected').text()

    # 五种题型的验证 错误回显+生成记录
    @$elm.on "click", ".submit-answer", (event)=>
      kind = $(event.target).parent().find('.question-type p').text()
      switch kind
        when 'fill'
          fill_question_array = []
          fill_question_array_length = @$elm.find('.question-fill-list .question-fill').length
          for x in [1..fill_question_array_length]
            fill_question_array.push(@$elm.find(".question-fill-list input:eq(#{x-1})").val())
          @fill_validation(fill_question_array)

        when 'mapping'
          mapping_array = []
          mapping_array_length =  @$elm.find(".question-mapping-list select").length
          for x in [1..mapping_array_length]
            mapping_key = @$elm.find(".question-mapping-list .mapping-pair .mapping-key:eq(#{x-1})").text()
            mapping_value = @$elm.find(".question-mapping-list select:eq(#{x-1})").val()
            mapping_array.push([mapping_key,mapping_value])
          @mapping_validation(mapping_array)

        when 'multi_choice'
          if @$elm.find('.question-multi-choice input:checked').length < 2
            alert('多选题至少要选择2项提交')
          else
            multi_choice_array = []
            multi_choice_array_length = @$elm.find(".question-multi-choice .option").length
            for x in [1..multi_choice_array_length]
              multi_choice_option = @$elm.find(".question-multi-choice .option input:eq(#{x-1})").attr("data-option")
              if @$elm.find(".question-multi-choice .option input:eq(#{x-1})").is(':checked')
                option_check_information = true
              else
                option_check_information = false
              multi_choice_array.push([multi_choice_option,option_check_information])
            @multi_choice_validation(multi_choice_array)

        when 'single_choice'
          checked_option = @$elm.find(":checked").closest('.option-radio input').attr("value")
          @single_choice_validation(checked_option)

        when 'bool'
          checked_option = @$elm.find(":checked").closest('.option input').attr("value")
          @bool_validation(checked_option)

        when 'essay'
          filled_content = @$elm.find(".question-essay textarea").val()
          @essay_without_validation(filled_content)
  window.DoQuestion = DoQuestion
$(document).on 'ready page:load', ->
  if $('.do-question-page').length > 0
    new DoQuestion $('.do-question-page')

# $(document).on 'ready page:change', ->
#   if $('.redo-question-page').length > 0
#     console.log('重做')
