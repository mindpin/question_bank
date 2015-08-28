# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery(document).ready ->
  jQuery(document).on('click','.page-new-question-single-choice .add-choice',->
    n = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').length - 1
    dom = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio:first').clone()
    dom.removeClass('hidden')
    dom.find('#question_choices').val("")
    dom.find('input:first').val(n)
    jQuery('.page-new-question-single-choice .add-choice').before(dom);
  )

  jQuery(document).on('click','.page-new-question-single-choice .delete-choice',->
    a = parseInt(jQuery(this).closest('.radio').find('input:first').val()) + 1
    m = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').length
    jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').eq(i).find('input:first').val(i - 2) for i in [a..m]
    jQuery(this).closest('.radio').remove()
  )

  jQuery(document).on('click','.page-new-question-single-choice .btn-default:last',->
    m = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').length
    n = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').length - 1
    dom = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio:first').clone()
    dom.removeClass('hidden')
    dom.find('#question_choices').val("")
    dom.find('input:first').val(n)
    jQuery('.page-new-question-single-choice .add-choice').before(dom) if (m == 2)
    jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio.hidden').remove()
  )

  jQuery(document).on('click','.page-new-question-multi-choice .add-choice',->
    n = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').length - 1
    dom = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox:first').clone()
    dom.removeClass('hidden')
    dom.find('#question_choices').val("")
    dom.find('input:first').val(n)
    jQuery('.page-new-question-multi-choice .add-choice').before(dom)
  )

  jQuery(document).on('click','.page-new-question-multi-choice .delete-choice',->
    a = parseInt(jQuery(this).closest('.checkbox').find('input:first').val()) + 1 
    m = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').length
    jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').eq(i).find('input:first').val(i - 2) for i in [a..m]
    jQuery(this).closest('.checkbox').remove()
  )

  jQuery(document).on('click','.page-new-question-multi-choice .btn-default:last',->
    m = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').length
    n = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').length - 1
    dom = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox:first').clone()
    dom.removeClass('hidden')
    dom.find('#question_choices').val("")
    dom.find('input:first').val(n)
    jQuery('.page-new-question-multi-choice .add-choice').before(dom) if (m == 2)
    jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox.hidden').remove()
  )