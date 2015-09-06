jQuery(document).on "ready page:load", ->
  new SingleChoice jQuery('.form-question-single-choice')
  new MultiChoice jQuery('.form-question-multi-choice')
  new Mapping jQuery('.form-question-mapping')
  new Fill jQuery('.form-question-fill')
class SingleChoice
  constructor: (@$sin)->
    @bind_events()

  bind_events: ->
    that = this

    @$sin.on 'click', '.add-choice', ->
      $choice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')
      next_choice_answer_index = $choice_answer_indexs.find('.radio:not(.hidden)').length
      dom = $choice_answer_indexs.find('.radio:first').clone()
      dom.removeClass('hidden')
      dom.find('input[name="question[choices][]"]').val("")
      dom.find('input[name="question[choice_answer_indexs][]"]').val(next_choice_answer_index)
      jQuery(this).before(dom)

    @$sin.on 'click', '.delete-choice', ->
      $choice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')

      $delete_radio = jQuery(this).closest('.radio')
      delete_index  = parseInt($delete_radio.find('input:first').val())
      last_index    = $choice_answer_indexs.find('.radio:not(.hidden)').length - 1
      for index in [delete_index..last_index]
        $radio = $choice_answer_indexs.find('.radio:not(.hidden)').eq(index)
        $radio.find('input:first').val(index - 1)

      $delete_radio.remove()


    @$sin.on 'submit', (evt)->
      $choice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')
      $choice_answer_indexs.find('.radio.hidden').remove()
class MultiChoice
  constructor: (@$mul)->
    @bind_events()

  bind_events: ->
    that = this

    @$mul.on 'click', ' .add-choice', ->
      $choice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')
      next_choice_answer_index = $choice_answer_indexs.find('.checkbox:not(.hidden)').length
      dom = $choice_answer_indexs.find('.checkbox:first').clone()
      dom.removeClass('hidden')
      dom.find('input[name="question[choices][]"]').val("")
      dom.find('input[name="question[choice_answer_indexs][]"]').val(next_choice_answer_index)
      jQuery(this).before(dom)

    @$mul.on 'click', ' .delete-choice', ->
      $choice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')

      $delete_checkbox = jQuery(this).closest('.checkbox')
      delete_index = parseInt($delete_checkbox.find('input:first').val())
      last_index   = $choice_answer_indexs.find('.checkbox:not(.hidden)').length - 1
      for index in [delete_index..last_index]
        $checkbox = $choice_answer_indexs.find('.checkbox:not(.hidden)').eq(index)
        $checkbox.find('input:first').val(index - 1)

      $delete_checkbox.remove()

    @$mul.on 'submit', ' form', (evt)->
      $choice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')
      $choice_answer_indexs.find('.checkbox.hidden').remove()
class Mapping
  constructor: (@$map)->
    @bind_events()

  bind_events: ->
    that = this

    @$map.on 'click',' .delete',->
      position_atr = jQuery(this).closest('.item').find('input').attr('name');
      zhengze = new RegExp(/[0-9]+/)
      position = zhengze.exec(position_atr)
      item_length = jQuery(".form-question-mapping .item").length
      x
      for x in [position...item_length]
        q = x - 1
        jQuery(".form-question-mapping .item").eq(x).find("input").attr('name','question[mapping_answer]['+q+'][]')
      if item_length == 1
        fuben = jQuery(".form-question-mapping .item:first").clone()
        jQuery(".form-question-mapping .item:first").after(fuben)
        jQuery(".form-question-mapping .item:last").addClass('hidden')
      jQuery(this).closest('.item').remove();

    @$map.on 'click',' .append',->
      count_hidden = jQuery('.option-key-field .hidden').length
      if count_hidden == 1
        jQuery('.option-key-field .hidden input').attr('name','question[mapping_answer][0][]')
        jQuery('.option-key-field .hidden' ).removeClass('hidden')
      else
        shuzi = jQuery('.form-question-mapping .item:last input ').attr('name');
        zhengze = new RegExp(/[0-9]+/)
        shuzi = zhengze.exec(shuzi)
        shuzi = Number(shuzi) + 1
        atr = jQuery(this).closest('.form-question-mapping').find(".item:last").clone()
        jQuery(this).closest('.add-items').before(atr);
        jQuery(this).closest('.form-question-mapping').find(".item:last").removeClass('hidden')
        jQuery(this).closest('.form-question-mapping').find(".item:last input").attr('name','question[mapping_answer]['+shuzi+'][]')
        jQuery(this).closest('.form-question-mapping').find(".item:last input").val()
class Fill
  constructor: (@$fill)->
    @bind_events()

  bind_events: ->
    that = this

    @$fill.on 'click','.insert',->
      str = jQuery('.form-question-fill').find("[name='question[content]']").val();
      str = str+" ___ "
      jQuery('.form-question-fill').find("[name='question[content]']").val(str);

    @$fill.on 'click','.delete ',->
      jQuery(this).closest(".answer").remove()

    @$fill.on 'click',' .append',->
      blank = jQuery('.form-question-fill .answer:last').clone();
      blank.removeClass("hidden")
      blank.find("input").val("")
      jQuery('.form-question-fill .answer:last').after(blank)


