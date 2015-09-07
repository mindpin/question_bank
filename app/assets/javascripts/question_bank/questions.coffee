class MappingMacker
  constructor: (@$elm)->
    @bind_events()
  bind_events: ->
    that = this
    num_filter = "/[0-9]+/"
    @$elm.on 'click', '.delete', ->
      position_atr = $(this).closest('.item').find('input').attr('name');
      position = that.regular(num_filter,position_atr)
      item_length = $(".form-question-mapping .item").length
      that.all_decrease(position,item_length)
      $(this).closest('.item').remove();

    @$elm.on 'click', '.append', ->
      count_hidden = $('.option-key-field .hidden').length
      if count_hidden == 1
        $('.option-key-field .hidden' ).find('input').attr('name','question[mapping_answer][0][]')
        $('.option-key-field .hidden' ).removeClass('hidden')
      else
        position_num = $('.form-question-mapping .item:last input ').attr('name');
        num = that.regular(num_filter,position_num)
        num = Number(num)+1
        atr = $('.form-question-mapping').find(".item:last").clone()
        that.$elm.find('.add-items').before(atr);
        last_mapping = $(this).closest('.form-question-mapping').find(".item:last")
        last_mapping.removeClass('hidden')
        last_mapping.find('input').attr('name','question[mapping_answer]['+num+'][]')
        last_mapping.find('input').val('') 
  regular: (filter, str)->
    regular_deal = new RegExp(filter)
    regular_deal.exec(str)

  all_decrease: (position,length)->
    for x in [position...length]
      q = x-1
      $(".form-question-mapping").find(".item").eq(x).find("input").attr('name','question[mapping_answer]['+q+'][]')
    if length==1
      $(".form-question-mapping").find(".item:first input").val("")
      copy = $(".form-question-mapping .item:first").clone()
      $(".form-question-mapping").find(".item:first").after(copy)
      $(".form-question-mapping").find(".item:last").addClass('hidden')
      $(".form-question-mapping").find(".item:last input").attr('name','question[mapping_answer][0][]')
class FillMacker
  constructor: (@$elm)->
    @bind_events()
  bind_events: ->
    @$elm.on 'click', '.append', =>
      blank = $('.form-question-fill .answer:last').clone();
      blank.removeClass("hidden")
      blank.find("input").val("")
      $(".form-question-fill").find(".answer:last").after(blank)     

    @$elm.on 'click', '.insert', ->
      str = $(".form-question-fill").find("[name='question[content]']").val()+" ___ "
      $(".form-question-fill").find("[name='question[content]']").val(str);

    @$elm.on 'click', '.delete', ->
      count = $().find('.answer').length
      if count == 1
        fuben = $(this).closest(".answer").clone()
        fuben.addClass('hidden')
        fuben.find('input').attr('value','')
        fuben.find('input').val('')
        $(this).closest(".answer").before(fuben)
      $(this).closest(".answer").remove()

    @$elm.on 'submit', 'form', ->
      if $(".form-question-fill").find('.answer:not(.hidden)').length > 0
        $(".form-question-fill").find('.answer.hidden').remove()

$(document).on "ready page:load", ->
  new FillMacker $('.form-question-fill')
  new MappingMacker $('.form-question-mapping')
