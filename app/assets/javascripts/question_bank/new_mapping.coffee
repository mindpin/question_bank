$(document).on 'click','.form-question-mapping .delete',->
  position_atr = $(this).closest('.item').find('input').attr('name');
  zhengze = new RegExp(/[0-9]+/)
  position = zhengze.exec(position_atr)
  item_length = $(".form-question-mapping .item").length
  x
  for x in [position...item_length]
    q = x-1
    $(".form-question-mapping .item").eq(x).find("input").attr('name','question[mapping_answer]['+q+'][]')
  if item_length==1
    fuben = $(".form-question-mapping .item:first").clone()
    $(".form-question-mapping .item:first").after(fuben)
    $(".form-question-mapping .item:last").addClass('hidden')
  $(this).closest('.item').remove();

$(document).on 'click','.form-question-mapping .append',->
  count_hidden = $('.option-key-field .hidden').length
  if count_hidden==1
    $('.option-key-field .hidden input').attr('name','question[mapping_answer][0][]')
    $('.option-key-field .hidden' ).removeClass('hidden')
  else
    shuzi = $('.form-question-mapping .item:last input ').attr('name');
    zhengze = new RegExp(/[0-9]+/)
    shuzi = zhengze.exec(shuzi)
    shuzi = Number(shuzi)+1
    atr = $(this).closest('.form-question-mapping').find(".item:last").clone()
    $(this).closest('.add-items').before(atr);
    $(this).closest('.form-question-mapping').find(".item:last").removeClass('hidden')
    $(this).closest('.form-question-mapping').find(".item:last input").attr('name','question[mapping_answer]['+shuzi+'][]')
    $(this).closest('.form-question-mapping').find(".item:last input").val('')