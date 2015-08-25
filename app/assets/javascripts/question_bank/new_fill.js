
  jQuery(document).on('click','.page-new-question-fill .insert',function(){
  var str = jQuery('.page-new-question-fill .input-filed').find('textarea').val();
  str = str +" ___ "
  jQuery('.page-new-question-fill .input-filed').find('textarea').val(str);


  var blank = jQuery('.page-new-question-fill .answer:last').clone();
  jQuery('.page-new-question-fill .answer:last').after(blank)
  jQuery('.page-new-question-fill .answer:last .hidden').removeClass('hidden')
  jQuery('.page-new-question-fill .answer:last input').val("")
  jQuery('.page-new-question-fill .hidden').remove()
  })

  jQuery(document).on('click','.page-new-question-fill .delete',function(){
   jQuery(this).closest('.answer').remove()
  })

