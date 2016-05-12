@CreateWare =
  video: (chapter)->
    ->
      open_modal <CreateWareForm.Video chapter={chapter} />


CreateWareForm =  
  Video: React.createClass
    displayName: 'CreateWareForm.Video'
    getInitialState: ->
      uploaded: false
    render: ->
      <div>
        <h4 className='ui header'>上传视频并创建课件</h4>
        <VideoUpload ref='upload' />
        <div className='buttons'>
          {
            if @state.uploaded
              <a href='javascript:;' className='ui button green small' onClick={@ok}>
                <i className='icon check' /> 确定保存
              </a>
          }

          <a href='javascript:;' className='ui button small' onClick={@close}>
            <i className='icon close' /> 关闭
          </a>
        </div>
      </div>

    componentDidMount: ->
      @refs.upload?.ee
        .on 'local_done', =>
          @setState uploaded: true
        .on 'start', =>
          @setState uploaded: false

    close: ->
      # 停止上传组件上传
      @refs.upload?.stop?()

      React.unmountComponentAtNode @state.$modal_dom.find('.content')[0]
      
      @state
        .$modal_dom
        .modal('hide')
        .remove()

    ok: ->
      data = @refs.upload?.get_data?()
      @props.chapter.add_ware data
      @close()


open_modal = (component)->
  $dom = jQuery """
    <div class="ui modal ware">
      <div class="content">
      </div>
    </div>
  """
    .appendTo document.body

  a = React.render component, $dom.find('.content')[0]
  a.setState $modal_dom: $dom

  $dom
    .modal
      blurring: true
      closable: false
    .modal('show')