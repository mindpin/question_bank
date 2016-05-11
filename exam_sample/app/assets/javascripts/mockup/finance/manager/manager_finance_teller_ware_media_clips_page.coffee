@ManagerFinanceTellerWareMediaClipsPage = React.createClass
  getInitialState: ->
    media_clips: @props.data.media_clips

  render: ->
    <div className='manager-finance-teller-ware-media-clips-page'>
    {
      if @state.media_clips.length is 0
        data =
          header: '前端课件媒体资源管理'
          desc: '还没有上传任何资源'
          init_action: <ManagerFinanceTellerWareMediaClipsPage.CreateBtn />
        <ManagerFuncNotReady data={data} />

      else
        <div>
          <ManagerFinanceTellerWareMediaClipsPage.CreateBtn />
          <ManagerFinanceTellerWareMediaClipsPage.Table media_clips={@state.media_clips} paginate={@props.data.paginate} search={@props.data.search} />
        </div>
    }
    </div>

  componentDidMount: ->
    Actions.set_store new DataStore @

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            cid: '资源标识'
            editable_name: '资源名称'
            kind: '类型'
            editable_desc: '描述'
            created_at: '更新时间'
            actions: '操作'
          data_set: @props.media_clips.map (x)=>
            jQuery.extend {
              actions:
                <a href={x.file_info.url} target='_blank' className='ui button basic mini'>
                  <i className='icon download' /> 预览
                </a>
              kind: x.file_info.kind
              editable_name:
                <InlineInputEdit value={x.name} on_submit={@update_name(x)} />
              editable_desc:
                <InlineInputEdit value={x.desc} on_submit={@update_desc(x)} />
            }, x

          th_classes: {}
          td_classes: {
            editable_name: 'collapsing'
            created_at: 'collapsing'
            actions: 'collapsing'
            kind: 'collapsing'
            cid: 'collapsing'
          }

          paginate: @props.paginate
          search: @props.search
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='前端课件媒体资源' />
        </div>

      update_name: (clip)->
        (name)->
          Actions.update_mclip clip, {
            name: name
          }

      update_desc: (clip)->
        (desc)->
          Actions.update_mclip clip, {
            desc: desc
          }

    CreateBtn: React.createClass
      render: ->
        <a className='ui button green mini' href='javascript:;' onClick={@upload_modal}>
          <i className='icon upload' />
          上传资源
        </a>

      upload_modal: ->
        jQuery.open_modal <ManagerFinanceTellerWareMediaClipsPage.UploadModal />, {
          closable: false
        }

    UploadModal: React.createClass
      getInitialState: ->
        uploaded: false
      render: ->
        <div>
          <h4 className='ui header'>上传资源</h4>
          
          <TellerWareMClipUpload ref='upload' />

          <div className='buttons' style={textAlign: 'right'}>
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

      ok: ->
        data = @refs.upload?.get_data?()
        Actions.create_mclip data, =>
          @state.close()


      close: ->
        @state.close()



class DataStore
  constructor: (@page)->
    @create_url = @page.props.data.create_url
    @media_clips = Immutable.fromJS @page.state.media_clips

  create_mclip: (data, callback)->
    # console.log @create_url
    # console.log clip: data
    jQuery.ajax
      type: 'POST'
      url: @create_url
      data: clip: data
    .done (res)=>
      @reload_page @media_clips.unshift(Immutable.fromJS(res.clip))
      callback?()

  update_mclip: (mclip, data)->
    jQuery.ajax
      type: 'PUT'
      url: mclip.update_url
      data: clip: data
    .done (res)=>
      @reload_page @media_clips.map (x)->
        x = x.merge data if x.get('id') is mclip.id
        x
    .fail (res)->
      console.log res.responseJSON

  reload_page: (media_clips)->
    @media_clips = media_clips
    @page.setState
      media_clips: media_clips.toJS()


Actions = class
  @set_store: (store)->
    @store = store

  @create_mclip: (data, callback)->
    @store.create_mclip data, callback

  @update_mclip: (clip, data)->
    @store.update_mclip clip, data