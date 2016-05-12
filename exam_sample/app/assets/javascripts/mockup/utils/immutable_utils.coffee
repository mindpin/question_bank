@ImmutableArrayUtils = class
  @index_of: (immutable_arr, item)->
    immutable_arr.toJS()
      .map (x)-> x.id
      .indexOf item.id

  @exange: (immutable_arr, id0, id1)->
    x0 = immutable_arr.get id0
    x1 = immutable_arr.get id1
    if x0? and x1?
      immutable_arr.set(id0, x1).set(id1, x0)
    else
      immutable_arr

  @move_up: (immutable_arr, item)->
    idx = @index_of immutable_arr, item
    if idx > 0
      @exange immutable_arr, idx, idx - 1
    else
      immutable_arr

  @move_down: (immutable_arr, item)->
    idx = @index_of immutable_arr, item
    if idx < immutable_arr.size - 1 and idx > -1
      @exange immutable_arr, idx, idx + 1
    else
      immutable_arr

  @delete: (immutable_arr, item)->
    immutable_arr.filter (x)->
      x.get('id') != item.id