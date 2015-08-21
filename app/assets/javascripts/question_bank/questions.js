jQuery(document).ready(function(){
  jQuery('#add_choice').click(function(){
    html =
      "<div class='radio_inline'>" + 
        "<input type = 'radio',name = '',id = '',value = ''>" +
        "&nbsp"+
        "<input type = 'text',name = '选项',id = '__'>" +
      "</div>" 
    jQuery('#add_choice').before(html);
  })
})