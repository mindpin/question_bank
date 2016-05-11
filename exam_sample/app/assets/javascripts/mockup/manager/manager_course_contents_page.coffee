@ManagerCourseContentsPage = React.createClass
  getInitialState: ->
    course: @props.data.course

  render: ->
    Chapter = ManagerCourseContentsPage.Chapter
    course = @state.course

    <div className='manager-course-contents-page'>
      <div className='ui segment'>
        <div className='chapters'>
          {
            for chapter, idx in course.chapters
              <Chapter key={chapter.id} data={chapter} idx={idx} chapters_size={course.chapters.length} />
          }
          {
            if course.chapters.length is 0
              <div className='ui info message'>还没有添加任何章节</div>
          }
          <div className='ch-actions'>
            {
              if @state.creating_chapter
                <div className='ui active small inline loader'></div>
              else
                <a href='javascript:;' onClick={@add_chapter}><i className='icon plus' /> 添加阶段</a>
            }
          </div>
          <div>
            <a className='ui button green' href={@props.data.manager_courses_url}>
              <i className='icon check' /> 保存课程
            </a>
          </div>
        </div>
      </div>
    </div>

  componentDidMount: ->
    Actions.set_store new DataStore @, @props.data.course

  add_chapter: ->
    Actions.add_chapter '未命名章节'

  statics:
    Chapter: React.createClass
      render: ->
        chapter = @props.data

        buttons_data = [
          {
            disabled: @props.idx is 0
            icon: 'arrow up'
            onclick: @move_up
            tip: '上移'
          },
          {
            disabled: @props.idx is @props.chapters_size - 1
            icon: 'arrow down'
            onclick: @move_down
            tip: '下移'
          },
          {
            icon: 'remove'
            onclick: @remove_confirm
            tip: '删除'
          }
        ]

        buttons =
          <BasicButtons data={buttons_data} />

        <div className='chapter' ref='chapter'>
          <div className='ch-header'>
            <label>第 <span className='idx'>{@props.idx + 1}</span> 章</label>
            <div className='content'>
              <InlineInputEdit value={chapter.name} on_submit={@change_name} />
            </div>
            {buttons}
          </div>
          <div className='wares'>
          {
            size = chapter.wares?.length
            for ware, idx in chapter.wares || []
              <ManagerCourseContentsPage.Ware key={ware.id} data={ware} idx={idx} wares_size={size}/>
          }
          </div>
          <div className='actions'>
            <a href='javascript:;' onClick={window.CreateWare.video(@)}><i className='icon upload' /> 上传视频</a>
          </div>
        </div>

      componentDidMount: ->
        # jQuery React.findDOMNode @refs.add_ware
        #   .popup
        #     popup: jQuery React.findDOMNode @refs.add_ware_popup
        #     position: 'top right'
        #     hoverable: true
        #     # delay:
        #     #   hide: 300

      change_name: (name)->
        Actions.change_chapter_name(@props.data, name)

      remove_confirm: ->
        jQuery.modal_confirm
          text: '确定要删除吗？'
          yes: =>
            jQuery React.findDOMNode @refs.chapter
              .hide 400, =>
                Actions.remove_chapter @props.data

      move_up: ->
        Actions.move_chapter_up @props.data

      move_down: ->
        Actions.move_chapter_down @props.data

      add_ware: (modal_data)->
        Actions.add_ware @props.data, modal_data


    Ware: React.createClass
      render: ->
        ware = @props.data

        buttons_data = [
          {
            disabled: @props.idx is 0
            icon: 'arrow up'
            onclick: @move_up
            tip: '上移'
          },
          {
            disabled: @props.idx is @props.wares_size - 1
            icon: 'arrow down'
            onclick: @move_down
            tip: '下移'
          },
          {
            icon: 'remove'
            onclick: @remove_confirm
            tip: '删除'
          }
        ]

        buttons =
          <BasicButtons data={buttons_data} />

        <div className='ware' ref='ware'>
          <div className='wa-header'>
            <label>小节 <span className='idx'>{@props.idx + 1}</span></label>
            <div className='content'>
              <InlineInputEdit value={ware.name} on_submit={@change_name} />
            </div>
            {buttons}
          </div>
        </div>

      change_name: (name)->
        Actions.change_ware_name @props.data, name

      remove_confirm: ->
        jQuery.modal_confirm
          text: '确定要删除吗？'
          yes: =>
            jQuery React.findDOMNode @refs.ware
              .hide 400, =>
                Actions.remove_ware @props.data

      move_down: ->
        Actions.move_ware_down @props.data

      move_up: ->
        Actions.move_ware_up @props.data




# -------------------



# 章节与课件编辑页面
class DataStore
  constructor: (@page, course)->
    @course = Immutable.fromJS course

  update_chapter: (chapter, data)->
    if not chapter.update_url?
      console.warn '没有传入 chapter.update_url 接口'
      return

    jQuery.ajax
      type: 'PUT'
      data: 
        chapter: data
      url: chapter.update_url
    .done (res)=>
      @reload_page @course.update 'chapters', (chapters)->
        chapters.map (c)->
          c = c.merge data if c.get('id') is chapter.id
          c
    .fail (res)->
      console.log res.responseJSON

  update_ware: (ware, data)->
    if not ware.update_url?
      console.warn '没有传入 ware.update_url 接口'
      return

    jQuery.ajax
      type: 'PUT'
      data:
        ware: data
      url: ware.update_url
    .done (res)=>
      @reload_page @course.update 'chapters', (chapters)->
        chapters.map (c)->
          c.update 'wares', (wares)->
            wares.map (w)->
              w = w.merge data if w.get('id') is ware.id
              w
    .fail (res)->
      console.log res.responseJSON

  delete_ware: (ware)->
    if not ware.delete_url?
      console.warn '没有传入 ware.delete_url 接口'
      return

    jQuery.ajax
      type: 'DELETE'
      url: ware.delete_url
    .done (res)=>
      @reload_page @course.update 'chapters', (chapters)->
        chapters.map (c)->
          c.update 'wares', (wares)->
            ImmutableArrayUtils.delete wares, ware
    .fail (res)->
      console.log res.responseJSON

  move_ware_down: (ware)->
    if not ware.move_down_url?
      console.warn '没有传入 ware.move_down_url 接口'
      return

    jQuery.ajax
      type: 'PUT'
      url: ware.move_down_url
    .done (res)=>
      @reload_page @course.update 'chapters', (chapters)->
        chapters.map (c)->
          c.update 'wares', (wares)->
            ImmutableArrayUtils.move_down wares, ware
    .fail (res)->
      console.log res.responseJSON

  move_ware_up: (ware)->
    if not ware.move_up_url?
      console.warn '没有传入 ware.move_up_url 接口'
      return

    jQuery.ajax
      type: 'PUT'
      url: ware.move_up_url
    .done (res)=>
      @reload_page @course.update 'chapters', (chapters)->
        chapters.map (c)->
          c.update 'wares', (wares)->
            ImmutableArrayUtils.move_up wares, ware
    .fail (res)->
      console.log res.responseJSON

  create_chapter: (data)->
    @page.setState creating_chapter: true

    jQuery.ajax
      type: 'POST'
      url: @page.props.data.manager_create_chapter_url
      data: 
        chapter: data
    .done (res)=>
      @reload_page @course.update 'chapters', (chapters)->
        res.wares = [] # bugfix
        chapters.push Immutable.fromJS res
    .always =>
      @page.setState creating_chapter: false

  delete_chapter: (chapter)->
    jQuery.ajax
      type: 'DELETE'
      url: chapter.delete_url
    .done (res)=>
      @reload_page @course.update 'chapters', (chapters)->
        ImmutableArrayUtils.delete chapters, chapter
    .fail (res)->
      console.log res.responseJSON

  move_chapter_down: (chapter)->
    if not chapter.move_down_url?
      console.warn '没有传入 chapter.move_down_url 接口'
      return

    jQuery.ajax
      type: 'PUT'
      url: chapter.move_down_url
    .done (res)=>
      @reload_page @course.update 'chapters', (chapters)->
        ImmutableArrayUtils.move_down chapters, chapter
    .fail (res)->
      console.log res.responseJSON

  move_chapter_up: (chapter)->
    if not chapter.move_up_url?
      console.warn '没有传入 chapter.move_up_url 接口'
      return

    jQuery.ajax
      type: 'PUT'
      url: chapter.move_up_url
    .done (res)=>
      @reload_page @course.update 'chapters', (chapters)->
        ImmutableArrayUtils.move_up chapters, chapter
    .fail (res)->
      console.log res.responseJSON

  create_ware: (chapter, data)->
    if not chapter.create_ware_url?
      console.warn '没有传入 chapter.create_ware_url 接口'
      return

    jQuery.ajax
      type: 'POST'
      data:
        ware: data
      url: chapter.create_ware_url
    .done (res)=>
      @reload_page @course.update 'chapters', (chapters)->
        chapters.map (ch)->
          if ch.get('id') is chapter.id
            ch = ch.update 'wares', (wares)->
              if res.id?
                wares.push Immutable.fromJS res
              else
                console.warn '创建课件请求没有返回正确数据'
          ch
    .fail (res)->
      console.log res.responseJSON

  reload_page: (course)->
    @course = course
    @page.setState
      course: @course.toJS()
      update: true



Actions = class
  @set_store: (store)->
    @store = store

  @change_chapter_name: (chapter, name)->
    @store.update_chapter chapter,
      name: name

  @change_ware_name: (ware, name)->
    @store.update_ware ware,
      name: name

  @remove_ware: (ware)->
    @store.delete_ware ware

  @move_ware_down: (ware)->
    @store.move_ware_down ware

  @move_ware_up: (ware)->
    @store.move_ware_up ware

  @add_chapter: (name)->
    @store.create_chapter
      name: name

  @remove_chapter: (chapter)->
    @store.delete_chapter chapter

  @move_chapter_up: (chapter)->
    @store.move_chapter_up chapter

  @move_chapter_down: (chapter)->
    @store.move_chapter_down chapter

  @add_ware: (chapter, data)->
    @store.create_ware chapter, data