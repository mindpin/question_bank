jQuery(document).on "ready page:load", ->
  jQuery(document).on 'click', '.form-question-single-choice .add-choice', ->
    $choice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')
    next_choice_answer_index = $choice_answer_indexs.find('.radio:not(.hidden)').length
    dom = $choice_answer_indexs.find('.radio:first').clone()
    dom.removeClass('hidden')
    dom.find('input[name="question[choices][]"]').val("")
    dom.find('input[name="question[choice_answer_indexs][]"]').val(next_choice_answer_index)
    jQuery(this).before(dom)

  jQuery(document).on 'click', '.form-question-single-choice .delete-choice', ->
    $choice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')

    $delete_radio = jQuery(this).closest('.radio')
    delete_index = parseInt($delete_radio.find('input:first').val())
    last_index   = $choice_answer_indexs.find('.radio:not(.hidden)').length - 1
    for index in [delete_index..last_index]
      $radio = $choice_answer_indexs.find('.radio:not(.hidden)').eq(index)
      $radio.find('input:first').val(index - 1)

    $delete_radio.remove()


  jQuery(document).on 'submit', '.form-question-single-choice form', (evt)->
    $choice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')
    $choice_answer_indexs.find('.radio.hidden').remove()


  jQuery(document).on 'click', '.form-question-multi-choice .add-choice', ->
    $choice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')
    next_choice_answer_index = $choice_answer_indexs.find('.checkbox:not(.hidden)').length
    dom = $choice_answer_indexs.find('.checkbox:first').clone()
    dom.removeClass('hidden')
    dom.find('input[name="question[choices][]"]').val("")
    dom.find('input[name="question[choice_answer_indexs][]"]').val(next_choice_answer_index)
    jQuery(this).before(dom)

  jQuery(document).on 'click', '.form-question-multi-choice .delete-choice', ->
    $choice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')

    $delete_checkbox = jQuery(this).closest('.checkbox')
    delete_index = parseInt($delete_checkbox.find('input:first').val())
    last_index   = $choice_answer_indexs.find('.checkbox:not(.hidden)').length - 1
    for index in [delete_index..last_index]
      $checkbox = $choice_answer_indexs.find('.checkbox:not(.hidden)').eq(index)
      $checkbox.find('input:first').val(index - 1)

    $delete_checkbox.remove()

  jQuery(document).on 'submit', '.form-question-multi-choice form', (evt)->
    $choice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')
    $choice_answer_indexs.find('.checkbox.hidden').remove()

