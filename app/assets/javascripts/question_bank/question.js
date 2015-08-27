jQuery(document).on('click',".page-new-question-mapping .delete",function(){

  var position_atr = jQuery(this).closest('.item').find('input').attr('name');
  var zhengze = new RegExp(/[0-9]+/)
  var position = zhengze.exec(position_atr)
  var item_length = jQuery(".page-new-question-mapping .item").length

  for(var i = position ; i < item_length ; i++){
    var q = i-1 
    jQuery(".page-new-question-mapping .item").eq(i).find("input").attr('name','question[mapping_answer]['+q+'][]')
  }

  if (item_length==1){
    var fuben = jQuery(".page-new-question-mapping .item:first").clone()
    jQuery(".page-new-question-mapping .item:first").after(fuben)
    jQuery(".page-new-question-mapping .item:last").addClass('hidden')
  }

  jQuery(this).closest('.item').remove();
})


jQuery(document).on('click','.page-new-question-mapping .append',function(){
  var count = jQuery('.option-key-field .item').length
  var count_hidden = jQuery('.option-key-field .hidden').length
  if (count_hidden==1){
    jQuery('.option-key-field .hidden input').attr('name','question[mapping_answer][0][]')
    jQuery('.option-key-field .hidden' ).removeClass('hidden')
  }else{
    var shuzi = jQuery('.page-new-question-mapping .item:last input ').attr('name');
    var zhengze = new RegExp(/[0-9]+/)
    var shuzi = zhengze.exec(shuzi)

    if (shuzi==null){
      shuzi = -1
    }

    shuzi = Number(shuzi)+1
    atr = jQuery(this).closest('.page-new-question-mapping').find(".item:last").clone()
    jQuery(this).closest('.add-items').before(atr);
    // /++
    jQuery(this).closest('.page-new-question-mapping').find(".item:last").removeClass('hidden')

    jQuery(this).closest('.page-new-question-mapping').find(".item:last input").attr('name','question[mapping_answer]['+shuzi+'][]')
    jQuery(this).closest('.page-new-question-mapping').find(".item:last input").val('')
  }
})


