@LayoutManagerSidebar = React.createClass
  render: ->
    <div className='manager-sidebar'>
      <div className='sidebar-inner'>
        {
          active = @props.data.current_func is @props.data.dashboard.id
          <LayoutManagerSidebar.Item data={@props.data.dashboard} active={active} />
        }
        {
          for scene, idx in @props.data.scenes
            <LayoutManagerSidebar.Scene key={idx} data={scene} parent={@} />
        }
      </div>
    </div>

  statics:
    Scene: React.createClass
      getInitialState: ->
        open: true

      render: ->
        url = @props.data.url || 'javascript:;'
        klass = new ClassName
          'scene': true
          'open': @state.open

        funcs_height = if @state.open then @props.data.funcs.length * 40 else 0

        <div className={klass}>
          <div className='si' onClick={@toggle}>
            {
              klass = new ClassName
                'icon': true
                'caret': true
                'right': not @state.open
                'down': @state.open
              <i className={klass} />
            }
            <span>{@props.data.name}</span>
          </div>
          <div className='funcs' style={'height': "#{funcs_height}px"}>
          {
            for func, idx in @props.data.funcs || []
              active = @props.parent.props.data.current_func is func.id
              <LayoutManagerSidebar.Item key={idx} data={func} active={active} />
          }
          </div>
        </div>

      toggle: ->
        @setState open: not @state.open


    Item: React.createClass
      render: ->
        klass = new ClassName
          'item': true
          'active': @props.active

        <div className={klass}>
          <a href={@props.data.url}>
            {
              klass = "icon #{@props.data.icon || 'circle'}"
              <i className="icon #{@props.data.icon}" />
            }
            <span>{@props.data.name}</span>
          </a>
        </div>