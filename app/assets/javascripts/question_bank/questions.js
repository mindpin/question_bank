jQuery(document).ready(function(){
  var n = 1
  jQuery('#add_choice').click(function(){
    n++
    var m = n + 1 
    html =
      "<div class='radio_inline'>" + 
        "<input type = 'radio' value = "+ n +" name = 'question[choice_answer_indexs][]' id = 'question_choice_answer_indexs_"+ n +"'>" +
        "&nbsp"+
        "<input type = 'text' name = 'question[choices][]' id = 'question_choices'>" +
      "</div>" 
    jQuery('#add_choice').before(html);
  })
})