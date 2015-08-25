jQuery(document).ready(function(){
  var n = 1
  jQuery('.new-single-choice .add-choice').click(function(){
    n++
    dom = jQuery('.new-single-choice .radio_inline:last').clone()
    dom.find('#question_choice_answer_indexs_2').val(n)
    jQuery('.new-single-choice .add-choice').before(dom);
  })
})