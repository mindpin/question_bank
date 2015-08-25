jQuery(document).ready(function(){
  var n = 1
  jQuery('.page-new-question-single-choice .add-choice').click(function(){
    n++
    dom = jQuery('.page-new-question-single-choice .question_choice_answer_indexs .radio:last').clone()
    dom.find('#question_choice_answer_indexs_2').val(n)
    jQuery('.page-new-question-single-choice .add-choice').before(dom);
  })

  jQuery('.page-new-question-multi-choice .add-choice').click(function(){
    n++
    dom = jQuery('.page-new-question-multi-choice .question_choice_answer_indexs .radio:last').clone()
    dom.find('#question_choice_answer_indexs_2').val(n)
    jQuery('.page-new-question-multi-choice .add-choice').before(dom);
  })
})
