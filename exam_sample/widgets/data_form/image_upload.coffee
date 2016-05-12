@DataForm.OneImageUploadField = React.createClass
  render: ->
    title = @props.title || '上传图片'
    
    <DataForm.Form.Field {...@props}>
      <OneImageUpload done={@props._set_value} file_entity_id={@props._value} />
    </DataForm.Form.Field>



# 用法：
# <OneImageUpload done={callback} value={value} />
# callback 回调方法，会被传入 file_entity.id
# value 预设值，用于“编辑修改”场景

OneImageUpload = React.createClass
  getInitialState: ->
    status: UploadStatus.READY
    percent: 0
    file_entity_id: @props.file_entity_id

  render: ->
    width = 640
    height = 360

    h = 180
    w = width * h / height

    browse_style = 
      width: "#{w}px"
      height: "#{h}px"

    <div className='image-upload'>
      <div className='browse' style={browse_style}>
        <OneImageUpload.Progress {...@state} />
        {
          title = @props.title || '上传图片'
          desc = @props.desc ||
            <div>
              支持 PNG/JPG/BMP 格式，最大 3MB <br/>
              建议图片尺寸大于 {width}×{height}px，最佳比例 16:9
            </div>

          <UploadWidget.BrowseButton ref='browse_btn' status={@state.status}>
            <div className='btn-text'>
              <div className='header'>＋ {title}</div>
              <div className='desc'>{desc}</div>
            </div>
          </UploadWidget.BrowseButton>
        }
      </div>
      <input type='hidden' value={@state.file_entity_id} readOnly />
    </div>

  statics:
    Progress: React.createClass
      render: ->
        if @props.status != UploadStatus.READY
          bar_style = 
            width: "#{100 - @props.percent}%"

          percent_style =
            if @props.preview_url?
              backgroundImage: "url(#{@props.preview_url})"

          <div className='percent' style={percent_style} >
            {
              if @props.status is UploadStatus.UPLOADING
                <div className='bar' style={bar_style} />
            }
            {
              switch @props.status
                when UploadStatus.UPLOADING
                  <div className='p'>{@props.percent}%</div>
                when UploadStatus.REMOTE_DONE
                  <div className='p'>
                    <div className='ui active inverted loader' />
                  </div>
                when UploadStatus.LOCAL_DONE
                  <div className='p'><i className='icon check circle' /></div>
            }
          </div>
        else
          <div />

  componentDidMount: ->
    $browse_button = jQuery React.findDOMNode @refs.browse_btn
    new QiniuFilePartUploader
      debug:                true
      browse_button:        $browse_button
      dragdrop_area:        null
      file_progress_class:  UploadUtils.GenerateOneFileUploadProgress(@)
      max_file_size:        '3MB' 
      mime_types :          [{ title: 'Image files', extensions: 'png,jpg,jpeg,bmp' }]

  on_upload_event: (evt, params...)->
    switch evt
      when 'start'
        qiniu_file = params[0]
        @set_preview_data_url qiniu_file

      when 'remote_done'
        qiniu_response_info = params[0]
        @set_preview_true_url qiniu_response_info

      when 'local_done'
        response_info = params[0]
        file_entity_id = response_info.file_entity_id
        @props.done? file_entity_id


  set_preview_data_url: (qiniu_file)->
    UploadUtils.load_image_data_url(
      qiniu_file.getNative(), 
      (data_url)=>
        @setState preview_url: data_url
    )

  set_preview_true_url: (qiniu_response_info)->
    UploadUtils.load_qiniu_image_url(
      qiniu_response_info, 
      (loaded_url)=>
        @setState preview_url: loaded_url
    )