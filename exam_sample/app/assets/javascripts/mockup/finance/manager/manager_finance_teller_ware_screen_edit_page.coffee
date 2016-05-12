@ManagerFinanceTellerWareScreenEditPage = React.createClass
  getInitialState: ->
    screen: @props.data.screen
    submiting: false
    saved: false

  render: ->
    screen = @state.screen
    a_klass = new ClassName
      'ui button green': true
      'loading': @state.submiting

    <div className='ui segment'>
      <h4 className='ui header'>编辑交易画面示例数据</h4>
      <OFCTellerScreen key={screen.hmdm} data={screen} editable ref='screen' />
      <div style={marginTop: '1rem'}>
        <a className={a_klass} onClick={@save}>
          <i className='icon save' /> 保存数据
        </a>
        {
          if @state.submiting
            <span style={marginLeft: '1rem'}>正在保存</span>
        }
        {
          if @state.saved
            <span style={marginLeft: '1rem'}><i className='icon checkmark' /> 保存完毕</span>
        }
      </div>
    </div>

  save: ->
    sample_data = @refs.screen.get_sample_data()

    @setState 
      submiting: true
      saved: false

    jQuery.ajax
      url: @state.screen.update_sample_data_url
      type: 'PUT'
      data: 
        hmdm: @state.screen.hmdm
        sample_data: sample_data
    .done (res)=>
      @setState 
        submiting: false
        saved: true
