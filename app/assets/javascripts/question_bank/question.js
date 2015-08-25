jQuery(document).ready(function(){
  jQuery(document).on('click','.page-new-mapping .delete',function(){
    jQuery(this).parent().remove();
   })
  jQuery(document).on('click','.page-new-mapping .append',function(){
    var count = jQuery('.option-key-field .item').length
    var shuzi = jQuery('.page-new-mapping .item:last input ').attr('name');
    var zhengze = new RegExp(/[0-9]+/)
    var shuzi = zhengze.exec(shuzi)
    if (shuzi==null){
      shuzi = -1
    }
    shuzi = Number(shuzi)+1
    atr = jQuery(this).closest('.page-new-mapping').find(".item:last").clone()
    jQuery(this).closest('.add-items').before(atr);
    jQuery(this).closest('.page-new-mapping').find(".item:last input").attr('name','question[mapping_answer]['+shuzi+'][]')
    if (count>1){
      jQuery(this).closest('.page-new-mapping').find(".item:last a").removeClass('hidden')
    }
   })
 })