# M3U8 plugin help for CKPlayer
# http://www.ckplayer.com/bbs/forum.php?mod=viewthread&tid=8947

# 使用该插件可以支持在pc端播放m3u8格式的视频文件
# 使用方法：
# 把m3u8.swf拷贝到index.htm同目录下(如果放在其它目录请注意flashvars里的路径要正确，而且不能放在其它域下)。在调用代码里作如下修改

# var flashvars={
#    f:'m3u8.swf',
#    a:'http://www.../m.m3u8',
#    c:0,
#    s:4,
#    lv:0//注意，如果是直播，需设置lv:1
# }
# 注意s:4
# 用该插件请注意，m3u8或m3u8里的ts文件是受到安全策略文件限制的，如果服务器用安全策略文件限制不让你播放的话，则该插件也无能为力。

# 其次，如果文件源是直播源，请注意设置flashvars里的lv:1


@Ware ||= {}

@Ware.Video = React.createClass
  render: ->
    data = @props.data

    # test
    # data.video_url = 'http://7xie1v.com1.z0.glb.clouddn.com/static_filesACU_Trailer_480.mp4'
    # data.video_url = 'http://7xie1v.com1.z0.glb.clouddn.com/static_fileACG_flv_big.flv'
    # data.video_url = 'http://7xie1v.com1.z0.glb.clouddn.com/static_fileACG_m3u8_1.m3u8'


    {#<Ware.Video.CKPlayerM3U8 data={@props.data} />}
    {#<Ware.Video.CKPlayerH5MP4 data={@props.data} />}
    {#<Ware.Video.CKPlayer data={@props.data} />}
    <Ware.Video.MediaElementMP4 data={@props.data} />

  statics:
    # 只能播放 MP4
    # FLASH 播放器不支持正确的拖动播放
    MediaElementMP4: React.createClass
      render: ->
        @box_id = "video-box-#{@props.data.id}"
        @widget_id = "video-#{@props.data.id}"

        <div className='widget-ware-video' ref='container'>
          <div className='wbox' id={@box_id}>
            <video controls='controls' preload='none' id={@widget_id} width='100%' height='100%'>
              <source type='video/mp4' src={@props.data.video_url} />
              <object width='100%'' height='100%' type="application/x-shockwave-flash" data='/mediaelement/flashmediaelement.swf'>
                <param name='movie' value='/mediaelement/flashmediaelement.swf' />
                <param name="flashvars" value="controls=true&file=#{@props.data.video_url}" />
              </object>
            </video>
          </div>
        </div>

      componentDidMount: ->
        window.player = @player = new MediaElementPlayer "##{@widget_id}", {
          # defaultVideoWidth: '100%'
          # defaultVideoHeight: '100%'
          # pluginWidth: '100%'
          # pluginHeight: '100%'
          # 试图修正尺寸 bug，然而这几个参数没什么用
        }

        jQuery(document).on 'ware:toggle-changed', @player_resize

      componentWillUnmount: ->
        jQuery(document).off 'ware:toggle-changed', @player_resize

      player_resize: ->
        @player.hideControls(false)



    CKPlayerM3U8: React.createClass
      render: ->
        @box_id = "video-box-#{@props.data.id}"
        @widget_id = "video-#{@props.data.id}"

        <div className='widget-ware-video'>
          <div className='wbox' id={@box_id}>
          </div>
        </div>

      componentDidMount: ->
        # flash_vars 含义参考: http://www.ckplayer.com/tool/#p_3_7_29
        flash_vars = 
          f: '/ckplayer/6.7/m3u8.swf'
          a: @props.data.video_url
          c: 0 # 调用 ckplayer.js 配置（不调用 xml 配置）
          s: 4 # flash 插件形式发送视频流地址给播放器进行播放
          lv: 0 # 不锁定进度栏

        video = ["#{@props.data.video_url}"]
        video = ["#{@props.data.video_url}->video/m3u8"]
        CKobject.embed '/ckplayer/6.7/ckplayer.swf', @box_id, @widget_id, '100%', '100%', false, flash_vars, video
        # CKobject.embedHTML5 @box_id, @widget_id, '100%', '100%', video, flash_vars, ['all'] 

    CKPlayerH5MP4: React.createClass
      render: ->
        @box_id = "video-box-#{@props.data.id}"
        @widget_id = "video-#{@props.data.id}"

        <div className='widget-ware-video'>
          <div className='wbox' id={@box_id}>
          </div>
        </div>

      componentDidMount: ->
        # flash_vars 含义参考: http://www.ckplayer.com/tool/#p_3_7_29
        flash_vars = 
          f: @props.data.video_url
          c: 0 # 调用 ckplayer.js 配置（不调用 xml 配置）
        
        # html5
        video = ["#{@props.data.video_url}->video/mp4"]
        CKobject.embedHTML5 @box_id, @widget_id, '100%', '100%', video, flash_vars, ['all'] 

    CKPlayer: React.createClass
      render: ->
        @box_id = "video-box-#{@props.data.id}"
        @widget_id = "video-#{@props.data.id}"

        <div className='widget-ware-video'>
          <div className='wbox' id={@box_id}>
          </div>
        </div>

      componentDidMount: ->
        # flash_vars 含义参考: http://www.ckplayer.com/tool/#p_3_7_29
        flash_vars = 
          f: @props.data.video_url
          c: 0 # 调用 ckplayer.js 配置（不调用 xml 配置）

        # flash
        video = null
        CKobject.embed '/ckplayer/6.7/ckplayer.swf', @box_id, @widget_id, '100%', '100%', false, flash_vars, video
        
        # html5
        # video = ["#{@props.data.video_url}->video/mp4"]
        # CKobject.embedHTML5 @box_id, @widget_id, '100%', '100%', video, flash_vars, ['all'] 

        setTimeout =>
          jQuery("##{@box_id}").css
            'width': null
            'height': null
            'background-color': null
        , 1