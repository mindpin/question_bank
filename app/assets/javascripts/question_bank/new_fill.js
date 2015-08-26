jQuery(document).on('click','.page-new-question-fill .insert',function(){
  var str = jQuery('.page-new-question-fill').find("[name='question[content]']").val();
  str = str +" ___ "
  jQuery('.page-new-question-fill').find("[name='question[content]']").val(str);
})

jQuery(document).on('click','.page-new-question-fill .delete ',function(){
  jQuery(this).parent().remove()
})

jQuery(document).on('click','.page-new-question-fill .append ',function(){ 
  var blank = jQuery('.page-new-question-fill .answer:last').clone();
  jQuery('.page-new-question-fill .answer:last').after(blank)
  jQuery('.page-new-question-fill .answer:last .hidden').removeClass('hidden')
  jQuery('.page-new-question-fill .answer:last input').val("")
})


$(document).on('submit','.page-new-question-fill form',function(){
  jQuery('.page-new-question-fill .hidden').remove()
});