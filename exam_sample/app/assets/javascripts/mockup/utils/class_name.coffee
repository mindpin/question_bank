@ClassName = class
  constructor: (@hash)->
  toString: ->
    arr = []
    for key, value of @hash
      arr.push key if value
    arr.join(' ')