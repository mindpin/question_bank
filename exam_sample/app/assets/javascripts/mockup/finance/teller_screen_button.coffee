@TellerScreenButton = React.createClass
  render: ->
    <a href='javascript:;' className='ui basic button mini' onClick={@show}>
      <i className='icon desktop' /> {@props.hmdm}
    </a>

  show: ->
    TellerScreenButton.load_modal @props.hmdm

  statics:
    Modal: React.createClass
      render: ->
        screen = @props.screen

        <div>
          <OFCTellerScreen key={screen.hmdm} data={screen} ref='screen'/>
          <div style={textAlign: 'right', marginTop: '2rem'}>
            <a href='javascript:;' className='ui button green' onClick={@play}>
              <i className='icon play' /> 演示
            </a>
            <a href='javascript:;' className='ui button green' onClick={@stop}>
              <i className='icon stop' /> 停止
            </a>
            <a href='javascript:;' className='ui button' onClick={@close}>关闭</a>
          </div>
        </div>

      close: ->
        @state.close()

      play: ->
        @refs.screen.play()

      pause: ->
        @refs.screen.pause()

      stop: ->
        @refs.screen.stop()

    load_modal: (hmdm)->
      hmdm_url = window.hmdm_url
      unless hmdm_url?
        console.warn '未设置 window.hmdm_url'
        return 

      jQuery.ajax
        url: hmdm_url
        data: hmdm: hmdm
      .done (screen)=>
        jQuery.open_modal(
          <TellerScreenButton.Modal screen={screen}/>, {
            allowMultiple: true
          }
        )


@TellerClipList = React.createClass
  getInitialState: ->
    infos: []

  render: ->
    <div className='ui divided list'>
    {
      for info in @state.infos
        <div key={info.cid} className='item'>
          <a href='javascript:;' onClick={@modal(info)}>{info.name}</a>
        </div>
    }
    </div>

  componentDidMount: ->
    @cids = @props.cids

    jQuery.ajax
      url: '/manager/finance/teller_ware_media_clips/get_infos'
      data: cids: @props.cids

    .done (res)=>
      @setState infos: res

  componentDidUpdate: ->
    if @cids != @props.cids
      @cids = @props.cids
      
      @setState infos: []

      jQuery.ajax
        url: '/manager/finance/teller_ware_media_clips/get_infos'
        data: cids: @props.cids

      .done (res)=>
        @setState infos: res

  modal: (info)->
    =>
      jQuery.open_modal(
        <div>
        {
          switch info.file_info.kind
            when 'image'
              style =
                width: 640
                height: 360
                backgroundImage: "url(#{info.file_info.url})"
                backgroundRepeat: 'no-repeat'
                backgroundSize: 'contain'
                backgroundPosition: 'center center'
              <div style={style} />
            when 'video'
              style =
                width: 640
                height: 360
              <video src={info.file_info.url} style={style} controls />
            else
              <div>
                <p>不支持该类型文件的直接展示，请点击按钮下载文件</p>
                <a href={info.file_info.url} className='ui button'>
                  <i className='icon download' download={info.name} />
                  下载附件
                </a>
              </div>
        }
        </div>
      )