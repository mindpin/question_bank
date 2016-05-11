@ManagerFuncNotReady = React.createClass
  render: ->
    <div className='ui segment func-not-ready'>
      <h3 className='ui header'>{@props.data.header}</h3>
      <div className='desc'>{@props.data.desc}</div>
      {
        if @props.data.init_action?
          <div className='ui divider' />
      }
      {
        if @props.data.init_action?
          @props.data.init_action
      }
    </div>