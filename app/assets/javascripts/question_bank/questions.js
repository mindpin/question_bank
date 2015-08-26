jQuery(document).ready(function(){
  jQuery('.page-new-question-single-choice .add-choice').click(function(){
    // .radio的数量等于最后的编号值+1
    var n = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').length
    dom1 = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio:first').clone()
    dom = dom1.append("<a class = 'btn btn-default delete-choice'>删除选项</a>")
    dom.find('#question_choice_answer_indexs_1').val(n)
    jQuery('.page-new-question-single-choice .add-choice').before(dom);
    jQuery('.page-new-question-single-choice .delete-choice').click(function(){
      var a = jQuery(this).closest('.radio').find('#question_choice_answer_indexs_1').val()
      var m = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').length
      for(var i = a ; i < m ; i++)
      { 
        jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio').eq(i).find('#question_choice_answer_indexs_1').val(i)
      }
      jQuery(this).closest('.radio').remove()
    })
  })

  jQuery('.page-new-question-multi-choice .add-choice').click(function(){
    var n = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').length
    dom1 = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox:first').clone()
    dom = dom1.append("<a class = 'btn btn-default delete-choice'>删除选项</a>")
    dom.find('#question_choice_answer_indexs_1').val(n)
    jQuery('.page-new-question-multi-choice .add-choice').before(dom);
    jQuery('.page-new-question-multi-choice .delete-choice').click(function(){
      var a = jQuery(this).closest('.checkbox').find('#question_choice_answer_indexs_1').val()
      var m = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').length
      for(var i = a ; i < m ; i++)
      { 
        jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .checkbox').eq(i).find('#question_choice_answer_indexs_1').val(i)
      }
      jQuery(this).closest('.checkbox').remove()
    })
  })
})
