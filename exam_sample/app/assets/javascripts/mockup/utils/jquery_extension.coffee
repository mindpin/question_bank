jQuery.is_blank = (obj)->
  not obj || jQuery.trim(obj) == ''

jQuery.blank_or = (obj, re)->
  unless jQuery.is_blank(obj)
  then obj
  else re

# ------------------------------

# 对Date的扩展，将 Date 转化为指定格式的String   
# 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符，   
# 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)   
# 例子：   
# jQuery.format_date new Date(), "yyyy-MM-dd hh:mm:ss.S" ==> 2006-07-02 08:09:04.423   
# jQuery.format_date new Date(), "yyyy-M-d h:m:s.S"      ==> 2006-7-2 8:9:4.18   

jQuery.format_date = (date, fmt)->
  o =
    "M+" : date.getMonth() + 1
    "d+" : date.getDate()
    "h+" : date.getHours()
    "m+" : date.getMinutes()
    "s+" : date.getSeconds()
    "q+" : Math.floor((date.getMonth() + 3) / 3) # 季度
    "S"  : date.getMilliseconds()

  if /(y+)/.test fmt
    fmt = fmt.replace RegExp.$1, "#{date.getFullYear()}".substr(4 - RegExp.$1.length)

  for k, v of o
    if new RegExp("(#{k})").test fmt
      fmt = fmt.replace RegExp.$1, if RegExp.$1.length == 1 then v else "00#{v}".substr "#{v}".length

  fmt

# --------------------------------


jQuery.flatten_tree = (tree_array, children_key)->
  res = Immutable.fromJS []

  _r = (tree_item, depth_array)->
    children = tree_item.get(children_key)
    children?.forEach (child, idx)->
      is_last_sibling = idx == children.size - 1
      child_depth_array = depth_array.push is_last_sibling
      x = child
        .delete(children_key)
        .set '_depth_array', child_depth_array
        .set '_depth', child_depth_array.size
        .set '_is_last_sibling', is_last_sibling
      res = res.push(x)
      _r child, child_depth_array

  tree_data = Immutable.fromJS "#{children_key}": tree_array

  _r tree_data, Immutable.fromJS([])

  return res.toJS()