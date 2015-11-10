class DoQuestion
  constructor: (@$elm)->
    @bind_events()

  multi_choice_validation: ()->
    console.log('multi_choice') 
  fill_validation: ()->
    console.log('fill') 

  bind_events: ->
    @$elm.find('.mapping-pair .select').change (event)=>
      changed_option = $(event.target).find('option:selected').text()
      if @before_click == '空'&&changed_option != '空'
        $(event.target).closest('.question-mapping').find("option[value =#{changed_option}]").addClass('hidden')
        $(event.target).find("option[value =#{changed_option}]").removeClass('hidden')
      if @before_click != '空'&&changed_option == '空'
        $(event.target).closest('.question-mapping').find("option[value =#{@before_click}]").removeClass('hidden')
    @$elm.find('.mapping-pair .select').click (event)=>
      @before_click = $(event.target).find('option:selected').text()
    # 五种题型的验证 错误回显+生成记录
    @$elm.on "click", ".submit-answer", (event)=>
      kind = $(event.target).parent().find('.question-type p').text()
      # if kind == 'fill'
      #   @fill_validation()
      switch kind
        when 'fill'
$(document).on 'ready page:load', ->
  if $('.do-question-page').length > 0 
    new DoQuestion $('.do-question-page')