class SelectOptionMutex
  constructor: (@$elm)->
    @bind_events()
    @get_options()

  get_options: ->
    @option_array = []
    option_length = @$elm.find(".question-mapping .select:first option").length
    for x in [0..option_length-1]
      @option_array.push(@$elm.find(".question-mapping .select:first option:eq(#{x})").attr('value'))
    index = $.inArray('空',@option_array)
    if index>=0
      @option_array.splice(index,1)

  bind_events: ->
    @$elm.find(".question-mapping .select").change (event)=>
      select_length = @$elm.find(".question-mapping .select").length
      selected_array = []
      for x in [0..select_length-1]
        selected_array.push(@$elm.find(".question-mapping option:selected:eq(#{x})").attr('value'))
      @$elm.find(".question-mapping option").removeClass('hidden')
      for x in [0..selected_array.length-1]
        @$elm.find("[value = #{selected_array[x]}]").addClass('hidden')
      @$elm.find("[value = '空']").removeClass('hidden') 

$(document).on 'ready page:load', ->
  if $('.do-question-page').length > 0
    new SelectOptionMutex $('.do-question-page')
  if $('.redo-question-page').length > 0
    new SelectOptionMutex $('.redo-question-page')
  if jQuery('.page-test-paper-result-new').length > 0
    new SelectOptionMutex jQuery('.page-test-paper-result-new')
