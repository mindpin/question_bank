@SimpleFormatText = React.createClass
  render: ->
    text = @props.text || ''
    if jQuery.is_blank(text)
      arr = [@props.placeholder]
    else
      text1 = text.replace(/ /g, "\u00a0")
      arr = text1.split("\n")

    <div className='simple-format-text'>
    {
      for s, idx in arr
        <div key={idx}>{s}</div>
    }
    </div>