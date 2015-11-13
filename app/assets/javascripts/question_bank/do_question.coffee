class DoQuestion
  constructor: (@$elm)->
    @bind_events()

  get_question_id: ()->
    @$elm.find('.question-id').attr('data-id')

  bool_validation: (bool_answer)->
    id = @get_question_id()
    $.ajax
        url: "/questions/do_question_validation",
        method: "post",
        data: {
          answer :bool_answer,
          answer_id:id,
          kind : 'bool'
        }
      .success (msg) ->


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
      .success (msg) ->

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
      .success (msg) ->

  multi_choice_validation: (answer_array)=>
    id = @get_question_id()
    $.ajax
        url: "/questions/do_question_validation",
        method: "post",
        data: {
          answer :checked_option,
          answer_id:id,
          kind : 'multi_choice'
        }
      .success (msg) ->

  mapping_validation: (answer_array)=>
    id = @get_question_id()
    $.ajax
        url: "/questions/do_question_validation",
        method: "post",
        data: {
          answer :checked_option,
          answer_id:id,
          kind : 'mapping'
        }
      .success (msg) ->



  bind_events: ->
    @$elm.find('.mapping-pair .select').change (event)=>
      changed_option = $(event.target).find('option:selected').text()
      if @before_click == '空'&&changed_option != '空'
        $(event.target).closest('.question-mapping-list').find("option[value =#{changed_option}]").addClass('hidden')
        $(event.target).find("option[value =#{changed_option}]").removeClass('hidden')
      if @before_click != '空'&&changed_option == '空'
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
          multi_choice_array = []
          multi_choice_array_length = @$elm.find(".question-multi-choice .option").length
          for x in [1..multi_choice_array_length]
            multi_choice_option = @$elm.find(".question-multi-choice .option input:eq(#{x-1})").attr("value")
            if @$elm.find(".question-multi-choice .option input:eq(#{x-1})").is(':checked')
              option_check_information = true
            else
              option_check_information = false
            multi_choice_array.push(multi_choice_option,option_check_information)
          @multi_choice_validation(multi_choice_array)

        when 'single_choice'
          checked_option = @$elm.find(":checked").closest('.option-radio input').attr("value")
          @single_choice_validation(checked_option)

        when 'bool'
          checked_option = @$elm.find(":checked").closest('.option input').attr("value")
          @bool_validation(checked_option)



$(document).on 'ready page:load', ->
  if $('.do-question-page').length > 0 
    new DoQuestion $('.do-question-page')