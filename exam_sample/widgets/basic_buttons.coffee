@BasicButtons = React.createClass
  render: ->
    <div className='ui basic icon buttons mini' ref='buttons'>
    {
      for sdata, idx in @props.data
        if sdata.disabled
          klass = 'ui button disabled'
          onclick = null
        else
          klass = 'ui button'
          onclick = sdata.onclick

        <a key={idx} className={klass} href='javascript:;' data-content={sdata.tip} data-variation='mini' onClick={onclick}>
          <i className="icon #{sdata.icon}" />
        </a>
    }
    </div>

  componentDidMount: ->
    jQuery React.findDOMNode @refs.buttons
      .find('.button')
      .popup()