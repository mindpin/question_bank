# 就绪，上传中，远程处理完毕，本地处理完毕，错误
@UploadStatus = {'READY', 'UPLOADING', 'REMOTE_DONE', 'LOCAL_DONE', 'ERROR'}

@UploadWidget =
  BrowseButton: React.createClass
    render: ->
      {READY, UPLOADING, REMOTE_DONE, LOCAL_DONE, ERROR} = UploadStatus

      style = switch @props.status
        when READY
          opacity: 1
        when UPLOADING, REMOTE_DONE
          display: 'none'
        when LOCAL_DONE, ERROR
          opacity: 0

      <div className='browse-btn' {...window.$$browse_btn_data} style={style}>
      {@props.children}
      </div>

@UploadUtils =
  # 如果是在 qiniu 的 progress 类里调用
  # 则使用 qiniu_uploading_file.getNative() 来获取第一个参数
  # 参考 OneImageUpload 里的实现
  load_image_data_url: (native_file, callback)->
    reader = new FileReader()
    reader.readAsDataURL native_file
    reader.onload = (e)->
      callback e.target.result

  # 让百分比数字变化更平滑，视觉体验较好
  smooth_percent: (p0, p1, callback)->
    jQuery({ num: p0 })
      .animate { num: p1 }, {
        step: (num)->
          callback(Math.ceil num)
      }

  # 根据七牛的上传信息获取图片地址
  # 该地址可以用于立即显示（图片已经在浏览器加载）
  load_qiniu_image_url: (qiniu_info, callback)->
    qiniu_domain = window.file_part_upload_dom_data?.qiniu_domain
    remote_url = "#{qiniu_domain}/#{qiniu_info.token}"
    jQuery("<img src='#{remote_url}' />").load ->
      callback remote_url

  # react 是某个 react component 的实例
  GenerateOneFileUploadProgress: (react)->
    class
      constructor: (@qiniu_file, uploader)->
        # if not react.on_upload_event?
        #   console.warn 'react component 上未定义用于处理上传逻辑的 on_upload_event 方法'

        react.setState
          status: UploadStatus.UPLOADING
          percent: 0
        react.on_upload_event? 'start', @qiniu_file

      # 某个文件上传进度更新时，此方法会被调用
      update: ->
        UploadUtils.smooth_percent(
          react.state.percent, 
          @qiniu_file.percent, 
          (smoothed_percent)->
            if react.isMounted()
              react.setState
                percent: smoothed_percent
        )

      # 当七牛上传成功，尝试创建 file_entity 时，此方法会被调用
      deal_file_entity: (qiniu_response_info)->
        react.setState
          status: UploadStatus.REMOTE_DONE
        react.on_upload_event? 'remote_done', qiniu_response_info

      # 某个文件上传成功并在本地实例化成功时，此方法会被调用
      success: (response_info)->
        react.setState 
          status: UploadStatus.LOCAL_DONE
          file_entity_id: response_info.file_entity_id
          file_entity_url: response_info.file_entity_url
        react.on_upload_event? 'local_done', response_info

      # 某个文件上传出错时，此方法会被调用
      file_error: (up, err, err_tip)->
        react.setState
          status: UploadStatus.ERROR
        react.on_upload_event? 'file_error', @qiniu_file

      file_entity_error: (xhr)->
        react.setState
          status: UploadStatus.ERROR
        react.on_upload_event? 'file_entity_error', xhr

      # 出现全局错误时（如文件大小超限制，文件类型不对），此方法会被调用
      @uploader_error: (up, err, err_tip)->
        console.warn err, err_tip
        switch err.code
          when -600
            react.on_upload_event? 'file_too_large', err

      # 所有上传队列项处理完毕时（成功或失败），此方法会被调用
      @alldone: ->