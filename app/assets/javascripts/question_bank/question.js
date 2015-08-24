jQuery(document).ready(function(){
  jQuery(document).on('click','.delete',function(){
    jQuery(this).parent().remove();
   })

  jQuery(document).on('click','.append',function(){

    var zhengze = new RegExp(/[0-9]+/)
    var str = jQuery('.item:last ').html();
    
    if (str==undefined){
      shuzi = 0
    }else{
      shuzi = zhengze.exec(str)
    }
     shuzi = Number(shuzi)+1
     
    atr1 = "<div class='item'>"+
            "<input type='text' name='[question][mapping_answer]["+shuzi+"][]' id='question_mapping_answer' class ='string optional'>"+"&nbsp"+
            "<input type='text' name='[question][mapping_answer]["+shuzi+"][]' id='question_mapping_answer' class ='string optional'>"+"&nbsp"+
            "<button class='delete' type='button'>删除连线</button>"+
           "</div>"+
           "<div class='add_items'>"+
              "<button class='append' type='button'> 添加一组选项</button>"+
              "请将正确答案连接"+
            "</div>"
    jQuery(this).closest('td').append(atr1);
    jQuery(this).parent().remove();
   })
 })