@SimpleInput = React.createClass
  render: ->
    value = @props.context.state[@props.bind]

    <input {...@props} ref='input'
      value={value} 
      onChange={@_change} 
      onKeyPress={@_press_enter} 
      onBlur={@props.on_submit}
      onFocus={@on_first_focus}
    />

  _change: (evt)->
    @props.context.setState
      "#{@props.bind}": evt.target.value

  _press_enter: (evt)->
    if evt.which is 13
      @props.on_submit?()

  focus: ->
    React.findDOMNode @refs.input
      .focus()

  on_first_focus: ->
    dom = React.findDOMNode @refs.input
    len = dom.value.length
    dom.setSelectionRange(len, len)