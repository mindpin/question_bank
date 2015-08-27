
  jQuery(document).on('click', '.page-new-question-single-choice .add-choice', function(){
    // .radio的数量等于最后的编号值+1
   var dom = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio:first').clone()
    var n = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').length
    dom.find('#question_choices').val("")
    dom.find('#question_choice_answer_indexs_1').val(n)
    jQuery('.page-new-question-single-choice .question_single_choice_answer .radio:last').after(dom);
  })

  jQuery(document).on('click','.page-new-question-single-choice .delete-choice',function(){
    var a = jQuery(this).closest('.radio').find('#question_choice_answer_indexs_1').val()
    var m = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').length
    for(var i = a ; i < m ; i++)
    {
      jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').eq(i).find('#question_choice_answer_indexs_1').val(i)
    }
    jQuery(this).closest('.radio').remove()
  })


// 多选的控制js
  jQuery(document).on('click', '.page-new-question-multi-choice .add-choice', function(){
    var n = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').length
    dom = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox:first').clone()
    dom.find('#question_choices').val("")
    dom.find('#question_choice_answer_indexs_1').val(n)
    jQuery('.page-new-question-multi-choice .add-choice').before(dom);
  })

  jQuery(document).on('click', '.page-new-question-multi-choice .delete-choice', function(){
    var a = jQuery(this).closest('.checkbox').find('#question_choice_answer_indexs_1').val()
    var m = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').length
    for(var i = a ; i < m ; i++)
    {
      jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').eq(i).find('#question_choice_answer_indexs_1').val(i)
    }
    jQuery(this).closest('.checkbox').remove()
  })


