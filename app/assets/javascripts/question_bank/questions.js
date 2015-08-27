jQuery(document).ready(function(){
  jQuery(document).on('click', '.page-new-question-single-choice .add-choice', function(){
    // .radio的数量等于最后的编号值+2
    var n = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').length - 1
    dom = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio:first').clone()
    dom.removeClass('hidden')
    dom.find('#question_choices').val("")
    dom.find('input:first').val(n)
    jQuery('.page-new-question-single-choice .add-choice').before(dom);
  })

  jQuery(document).on('click','.page-new-question-single-choice .delete-choice',function(){
    var a = parseInt(jQuery(this).closest('.radio').find('input:first').val()) + 1
    var m = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').length
    for(var i = a ; i < m ; i++)
    {
      // 最终应存入c = a - 1 = i - 2 
      var c = i - 2
      jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').eq(i).find('input:first').val(c)
    }
    jQuery(this).closest('.radio').remove()
  })

  jQuery(document).on('click','.page-new-question-single-choice .btn-default:last', function(){
    jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio.hidden').remove()
  })

  jQuery(document).on('click', '.page-new-question-multi-choice .add-choice', function(){
    var n = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').length - 1
    dom = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox:first').clone()
    dom.removeClass('hidden')
    dom.find('#question_choices').val("")
    dom.find('input:first').val(n)
    jQuery('.page-new-question-multi-choice .add-choice').before(dom);
  })

  jQuery(document).on('click', '.page-new-question-multi-choice .delete-choice', function(){
    var a = parseInt(jQuery(this).closest('.checkbox').find('input:first').val()) + 1 
    var m = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').length
    for(var i = a ; i < m ; i++)
    {
      // 最终应存入c = a - 1 = i - 2 
      var c = i - 2
      jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').eq(i).find('input:first').val(c)
    }
    jQuery(this).closest('.checkbox').remove()
  })

  jQuery(document).on('click','.page-new-question-multi-choice .btn-default:last', function(){
    jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox.hidden').remove()
  })

})
