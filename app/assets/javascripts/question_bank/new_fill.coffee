$(document).on 'click','.form-question-fill .insert',->
  str = $('.form-question-fill').find("[name='question[content]']").val();
  str = str+" ___ "
  $('.form-question-fill').find("[name='question[content]']").val(str);

$(document).on 'click','.form-question-fill .delete ',->
  $(this).closest(".answer").remove()

$(document).on 'click','.form-question-fill .append',->
  blank = $('.form-question-fill .answer:last').clone();
  blank.removeClass("hidden")
  blank.find("input").val("")
  $('.form-question-fill .answer:last').after(blank)
