class MappingMacker
  constructor: (@$elm)->
    @bind_events()
    @num_filter = /[0-9]+/

  get_mapping_input_name: (delete_btn)->
    delete_btn.closest('.item').find('input').attr('name');

  get_current_item_count: ()->
    @$elm.find(".question_mapping_answer .option-key-field .item").length

  change_item_name_index: (item, index)->
    item.find("input").attr('name','question[mapping_answer]['+index+'][]')

  change_items_index_when_delete: (delete_position, current_item_count)->
    for x in [delete_position...current_item_count]
      @change_item_name_index(@$elm.find(".item"), x-1)

  regular: (filter, str)->
    regular_deal = new RegExp(filter)
    regular_deal.exec(str)
    
    

  add_hidden_item_by_first_item: ()->
    @$elm.find('.question_mapping_answer .option-key-field .item:first' ).find('input').val("")
    copy = @$elm.find('.question_mapping_answer .option-key-field .item:first').clone()
    @$elm.find('.question_mapping_answer .option-key-field .item:first').after(copy)
    @$elm.find('.question_mapping_answer .option-key-field .item:last').addClass('hidden')

  get_hidden_item_count: ()->
    @$elm.find('.option-key-field .hidden').length

  hidden_item_remove_class: ()->
    @$elm.find('.option-key-field .hidden' ).find('input').attr('name','question[mapping_answer][0][]')
    @$elm.find('.option-key-field .hidden' ).removeClass('hidden')

  get_last_mapping_input: ()->
    @$elm.find('.question_mapping_answer .option-key-field .item:last input')

  add_new_mapping_item_by_last_item: (last_item)->
    @$elm.find('.add-items').before(last_item);

  add_new_mapping_item_index: (new_item,new_item_index)->
    new_item.attr('name','question[mapping_answer]['+new_item_index+'][]')
    new_item.val('')

  bind_events: ->
    @$elm.on 'click', '.delete', (evt)=>
      mapping_input_name = @get_mapping_input_name($(evt.target))
      delete_position = @regular(@num_filter, mapping_input_name)
      item_count = @get_current_item_count()
      if item_count == 1
        @add_hidden_item_by_first_item()
      else
        @change_items_index_when_delete(delete_position, item_count)
      $(evt.target).closest('.question_mapping_answer .option-key-field .item').remove();

    @$elm.on 'click', '.append', (evt)=>
      hidden_item_count = @get_hidden_item_count
      if hidden_item_count == 1
        @hidden_item_remove_class
      else
        last_mapping_input_name = @get_last_mapping_input().attr('name')
        last_mapping_input_index = @regular(@num_filter,last_mapping_input_name)
        new_mapping_input_index = Number(last_mapping_input_index)+1
        last_item_copy = @$elm.find(".question_mapping_answer .option-key-field .item:last").clone()
        @add_new_mapping_item_by_last_item(last_item_copy)
        new_last_mapping_item_input = @get_last_mapping_input()
        @add_new_mapping_item_index(new_last_mapping_item_input,new_mapping_input_index)
        @$elm.find('.question_mapping_answer .option-key-field .item:last').removeClass('hidden')


class FillMacker
  constructor: (@$elm)->
    @bind_events()
  make_new_blank_dom: ()->
    blank = @$elm.find('.answer:last').clone();
    blank.removeClass("hidden")
    blank.find("input").val("")
    blank

  add_new_blank: (new_blank)->
    @$elm.find(".question_fill_answer .answer:last").after(new_blank) 
  
  make_new_atr: ()->
    @$elm.find("[name='question[content]']").val()+" ___ "

  add_new_atr_in_blank: (str)->
    @$elm.find("[name='question[content]']").val(str);

  make_hidden_answer_when_answer_is_one:(delete_btn)->
    copy = delete_btn.closest(".answer").clone()
    copy.addClass('hidden')
    copy.find('input').attr('value','')
    copy.find('input').val('')
    $(evt.target).closest(".answer").before(copy)

  get_answer_which_is_not_hidden_count:()->
    @$elm.find('.question_fill_answer .answer:not(.hidden)').length

  remove_answer_which_is_not_hidden:()->
    @$elm.find('.question_fill_answer .answer.hidden').remove()

  get_answer_which_is_not_hidden_count:()->
    @$elm.find('.question_fill_answer .answer').length

  bind_events: ->
    @$elm.on 'click', '.append', =>
      new_blank_dom = @make_new_blank_dom();
      @add_new_blank(new_blank_dom)   

    @$elm.on 'click', '.insert', =>
      new_atr_in_blank = @make_new_atr()
      @add_new_atr_in_blank(new_atr_in_blank)

    @$elm.on 'click', '.delete',(evt)=>
      answer_input_count = @get_answer_input_count
      if answer_input_count == 1
        @make_hidden_answer_when_answer_is_one($(evt.target))
      $(evt.target).closest(".answer").remove()

    @$elm.on 'submit', 'form', =>
      answer_which_is_not_hidden_count = @get_answer_which_is_not_hidden_count
      if answer_which_is_not_hidden_count > 0
        @remove_answer_which_is_not_hidden()

$(document).on "ready page:load", ->
  if $('.form-question-fill').length > 0
    new FillMacker $('.form-question-fill')

  if $('.form-question-mapping').length > 0
    new MappingMacker $('.form-question-mapping')
