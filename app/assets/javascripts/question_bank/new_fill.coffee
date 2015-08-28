$(document).on 'click','.page-new-question-fill .insert',->
  str = $('.page-new-question-fill').find("[name='question[content]']").val();
  str = str+" ___ "
  $('.page-new-question-fill').find("[name='question[content]']").val(str);

$(document).on 'click','.page-new-question-fill .delete ',->
  $(this).closest(".answer").remove()

$(document).on 'click','.page-new-question-fill .append',->
  blank = $('.page-new-question-fill .answer:last').clone();
  blank.removeClass("hidden")
  blank.find("input").val("")
  $('.page-new-question-fill .answer:last').after(blank)
