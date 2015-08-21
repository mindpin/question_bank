jQuery(document).ready(function(){
  jQuery(document).on('click','.delete',function(){
    jQuery(this).parent().remove();
   })

  jQuery(document).on('click','.append',function(){
    atr1 = "<div class='item'>"+
            "<input type='text' name='query' id='query'>"+"&nbsp"+
            "<input type='text' name='query' id='query'>"+"&nbsp"+
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