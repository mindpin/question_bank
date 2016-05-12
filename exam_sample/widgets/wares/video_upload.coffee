@VideoUpload = React.createClass
  getInitialState: ->
    status: UploadStatus.READY
    percent: 0
    file_entity_id: @props.file_entity_id

    qiniu_file: null
    error_tip: null

  render: ->
    <div className='widget-video-upload'>
      <VideoUpload.BrowseButton ref='browse_btn' status={@state.status}>
        <div className='btn-text'>
          <div className='header'><i className='icon upload' /> 点击上传视频</div>
        </div>
      </VideoUpload.BrowseButton>

      <VideoUpload.Percent {...@state} />
      
      <VideoUpload.ErrorMessage {...@state} />

      <VideoUpload.WareForm {...@state} ref='form'/>

      <input type='hidden' value={@state.file_entity_id} readOnly />
    </div>


  statics:
    BrowseButton: React.createClass
      render: ->
        {READY, UPLOADING, REMOTE_DONE, LOCAL_DONE, ERROR} = UploadStatus

        style = switch @props.status
          when READY, LOCAL_DONE, ERROR
            <div className='browse-btn' {...window.$$browse_btn_data} style={style}>
            {@props.children}
            </div>
          when UPLOADING, REMOTE_DONE
            <div />

    Percent: React.createClass
      render: ->
        {READY, UPLOADING, REMOTE_DONE, LOCAL_DONE, ERROR} = UploadStatus

        switch @props.status
          when READY
            <div />
          when LOCAL_DONE
            <div className='ui success message'>
              <p><i className='icon check' /> 上传完毕</p>
            </div>
          else
            percent = @props.percent

            bar_style = 
              'transitionDuration': '300ms'
              'width': "#{percent}%"
            <div className='percent-bar'>
              <div className='filename'>正在上传 {@props.qiniu_file?.name}</div>
              <div className='ui indicating active progress' data-percent={percent}>
                <div className='bar' style={bar_style}>
                </div>
                {
                  switch @props.status
                    when REMOTE_DONE
                      <div className='label'><i className='notched circle loading icon' /> 正在处理</div>
                    else
                      <div className='label'>已上传 {percent}% </div>
                }
              </div>
            </div>

      componentDidUpdate: ->
        # if @props.status == UploadStatus.LOCAL_DONE
        #   jQuery React.findDOMNode @
        #     .delay(300)
        #     .hide(300)

    ErrorMessage: React.createClass
      render: ->
        if @props.error_tip?
          <div className='ui negative message'>
            <p>{@props.error_tip}</p>
          </div>
        else
          <div></div>

    WareForm: React.createClass
      render: ->
        if @props.status == UploadStatus.LOCAL_DONE
          {
            TextInputField
            TextAreaField
          } = DataForm

          layout =
            label_width: '80px'

          <div className='ui segment'>
            <h4 className='ui header'>视频信息</h4>
            <DataForm.Form ref='form'>
              <TextInputField {...layout} label='视频标题：' name='name' />
              <TextAreaField {...layout} label='视频简介：' name='desc' rows={10} />
            </DataForm.Form>
          </div>

        else
          <div />

      get_data: ->
        @refs.form.get_data?()


  componentDidMount: ->
    $browse_button = jQuery React.findDOMNode @refs.browse_btn
    @uploader = new QiniuFilePartUploader
      # debug: true
      browse_button:        $browse_button
      dragdrop_area:        null
      file_progress_class:  UploadUtils.GenerateOneFileUploadProgress(@)
      max_file_size:        '1024mb' 
      mime_types :          [{ title: 'Video Files', extensions: '*' }]

    @ee = new EventEmitter()

  on_upload_event: (evt, params...)->
    switch evt
      when 'start'
        qiniu_file = params[0]
        # 格式参考 http://i.teamkn.com/i/NU3tx6no.png
        @setState 
          error_tip: null
          qiniu_file: qiniu_file

        @ee.trigger 'start'

      when 'local_done'
        @ee.trigger 'local_done'

      when 'file_too_large'
        @setState error_tip: "文件太大了，最大支持上传 1G 文件"
      when 'file_error', 'file_entity_error'
        @setState error_tip: "文件上传出错"


  stop: ->
    # 参考 http://www.plupload.com/docs/Uploader
    @uploader.qiniu.stop()

  get_data: ->
    data = @refs.form.get_data?()
    
    {
      name: jQuery.blank_or data.name, '未命名视频'
      desc: data.desc
      file_entity_id: @state.file_entity_id
    }
