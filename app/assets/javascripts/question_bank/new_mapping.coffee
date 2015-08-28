$(document).on 'click','.page-new-question-mapping .delete',->
  position_atr = $(this).closest('.item').find('input').attr('name');
  zhengze = new RegExp(/[0-9]+/)
  position = zhengze.exec(position_atr)
  item_length = $(".page-new-question-mapping .item").length
  x
  for x in [position...item_length]
    q = x-1
    $(".page-new-question-mapping .item").eq(x).find("input").attr('name','question[mapping_answer]['+q+'][]')
  if item_length==1
    fuben = $(".page-new-question-mapping .item:first").clone()
    $(".page-new-question-mapping .item:first").after(fuben)
    $(".page-new-question-mapping .item:last").addClass('hidden')
  $(this).closest('.item').remove();

$(document).on 'click','.page-new-question-mapping .append',->
  count_hidden = $('.option-key-field .hidden').length
  if count_hidden==1
    $('.option-key-field .hidden input').attr('name','question[mapping_answer][0][]')
    $('.option-key-field .hidden' ).removeClass('hidden')
  else
    shuzi = $('.page-new-question-mapping .item:last input ').attr('name');
    zhengze = new RegExp(/[0-9]+/)
    shuzi = zhengze.exec(shuzi)
    shuzi = Number(shuzi)+1
    atr = $(this).closest('.page-new-question-mapping').find(".item:last").clone()
    alert atr.html()
    $(this).closest('.add-items').before(atr);
    $(this).closest('.page-new-question-mapping').find(".item:last").removeClass('hidden')
    $(this).closest('.page-new-question-mapping').find(".item:last input").attr('name','question[mapping_answer]['+shuzi+'][]')
    $(this).closest('.page-new-question-mapping').find(".item:last input").val('')