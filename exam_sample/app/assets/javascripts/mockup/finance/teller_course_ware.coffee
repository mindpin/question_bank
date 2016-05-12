@TellerCourseWare = React.createClass
  render: ->
    <div className='teller-course-ware'>
      <TellerCourseWare.Sidebar data={@baseinfo()} />
      <TellerCourseWare.Panel ware={@baseinfo()} data={@actioninfo()} />
    </div>

  baseinfo: ->
    @props.data.baseinfo || {}

  actioninfo: ->
    @props.data.actioninfo || {}

  statics:
    Sidebar: React.createClass
      render: ->
        data = @props.data

        gaishu =
          <div style={marginBottom: '2rem'}>
            <label><b>交易概述</b></label>
            <div className='gaishu'>
              <SimpleFormatText text={data.desc} placeholder='需要熟悉业务的人员填写' />
            </div>
          </div>

        gainian =
          <div style={marginBottom: '2rem'}>
            <label><b>关键概念</b></label>
            <pre>{data.gainian?[data.number]}</pre>
          </div>

        <div className='sidebar'>
          <div className='sibitem base'>
            <div className='number'>{data.number} - {data.business_kind_str}</div>
            <div className='name'>{data.name}</div>
          </div>

          <div className='sibitem desc'>
            {gaishu}

            {
              if data.relative_wares.length > 0
                <div style={marginBottom: '2rem'}>
                  <label><b>相关交易</b></label>
                  {
                    for ware in data.relative_wares
                      <a key={ware.id} className='relative-ware' href={ware.show_url} target='_blank'>
                        <div className='number'><b>{ware.number} - {ware.business_kind_str}</b></div>
                        <div>{ware.name}</div>
                      </a>
                  }
                </div>
            }
          </div>
        </div>

    Panel: React.createClass
      render: ->
        <div className='paper'>
          <OEP ware={@props.ware} data={@props.data} />
        </div>



# ----------------



OEP = React.createClass
  displayName: 'OEPreviewer'
  getInitialState: ->
    # data: @props.data
    # graph: new OEActionsGraph @props.data
    {}

  render: ->
    @state.graph = new OEActionsGraph @props.data

    <div className='flow-course-ware'>
      <OEP.Header data={@state.graph} />
      <OEP.Nodes oep={@} data={@state.graph} />
      <OEP.TeachingDialog oep={@} ref='dialog' data={@state.graph} ware={@props.ware} />
    </div>

  componentDidUpdate: ->
    @change_arrows()

  componentDidMount: ->
    @change_arrows()

    for id, action of @state.graph.actions
      if action.is_start()
        @focus_action action
        break

    for id, action of @state.graph.actions
      if action.is_start()
        @_r action, 0
        break

  _r: (action, idx)->
    action.idx = idx

    idx += 1
    for id, post_action of action.post_actions
      @_r post_action, idx

  change_arrows: ->
    # 画动态箭头
    role_pos = {}
    for role, actions of @state.graph.roles
      $lane = jQuery(".role-actions[data-role=#{role}]")
      role_pos[role] = $lane.position()

    @state.graph.draw_animate_arrow(role_pos)

  focus_action: (action)->
    @refs.dialog.show action

    jQuery('.action-node').removeClass('focus')
    jQuery(".action-node[data-id=#{action.id}]").addClass('focus')

  show_screen: (action)->
    @refs.screen_shower.show action

  statics:
    Header: React.createClass
      displayName: 'OEP.Header'
      render: ->
        <div className='header'>
          {
            for role in ['客户', '柜员']
              if @props.data.roles[role]?
                <div key={role} className="role #{role}">角色：{role}</div>
                
          }
        </div>

    Nodes: React.createClass
      displayName: 'OEP.Nodes'
      render: ->
        <div className='nodes'>
          <div className='nbox'>
          <canvas className='ncanvas' />
          {
            for role in ['客户', '柜员']
              if (role_actions = @props.data.roles[role])?
                <OEP.RoleActions oep={@props.oep} key={role} role={role} data={role_actions} />
          }
          </div>
        </div>

    RoleActions: React.createClass
      displayName: 'OEP.RoleActions'
      render: ->
        @bottom = 0
        @right = 0

        <div ref='panel' data-role={@props.role} className='role-actions'>
          {
            for id, action of @props.data
              pos = action.css_pos()
              @bottom = Math.max @bottom, pos.bottom
              @right = Math.max @right, pos.right

              <OEP.Action oep={@props.oep} key={id} data={action} />
          }
        </div>

      componentDidMount: ->
        @update_size()

      componentDidUpdate: ->
        @update_size()

      update_size: ->
        # 设置宽高
        $panel = jQuery React.findDOMNode @refs.panel
        $panel.css
          width: @right + OEAction.CSS_GAP
          height: @bottom + OEAction.CSS_GAP


    Action: React.createClass
      displayName: 'OEP.Action'
      render: ->
        action = @props.data
        pos = action.css_pos()
        style = 
          left: "#{pos.left}px"
          top: "#{pos.top}px"
          width: "#{OEAction.CSS_WIDTH}px"
          height: "#{OEAction.CSS_HEIGHT}px"
        klass = ['action-node']

        <div className={klass.join(' ')} data-role={action.role} data-deep={action.deep} style={style} data-id={action.id} onClick={@do_click}>
          <div className='box'>
            <div className='name'>{action.name}</div>
            {
              if action.screen_ids.length
                <div className='has-screen'>
                  <i className='icon desktop' />
                </div>
            }
            {
              if action.clip_ids.length
                <div className='has-clip'>
                  <i className='icon attach' />
                </div>
            }
          </div>
        </div>

      do_click: (evt)->
        @props.oep.focus_action @props.data


    TeachingDialog: React.createClass
      getInitialState: ->
        action: {}

      render: ->
        action = @state.action

        if Object.keys(action).length
          @prev_keys = Object.keys(action.pre_actions)
          @next_keys = Object.keys(action.post_actions)

          @has_prev = @prev_keys.length
          @has_next = @next_keys.length

          @has_screen = action.screen_ids?.length
          @has_clip = action.clip_ids?.length

        klass = ['teaching-dialog']
        klass.push 'has-screen' if @has_screen

        action_name =
          <div className="action-name #{action.role}">
            <span className='ct'>{action.name}</span>
          </div>

        nav =
          <div className='nav'>
            <div>
              <a href='javascript:;' onClick={@show_question_modal}>
                <i className='icon question'/>
                提问讨论
              </a>
              <a href='javascript:;' onClick={@show_note_modal}>
                <i className='icon pencil'/>
                记录笔记
              </a>
            </div>

            <div>
              <a href='javascript:;' onClick={@focus_prev}>
                <i className='icon chevron left'/>
                上一步　
              </a>
              <a href='javascript:;' onClick={@focus_next}>
                <i className='icon chevron right'/>
                下一步　
              </a>
            </div>
          </div>

        screen_show = 
          if @has_screen
            <div className='screen-show'>
              <div className='desc'>
                这个步骤需要通过前端系统屏幕进行操作 <br/>
                请点击下面的按钮来观看示例：
              </div>
              {
                for hmdm in action.screen_ids
                  <TellerScreenButton key={hmdm} hmdm={hmdm} />
              }
            </div>

          else
            <div />

        clip_show =
          if @has_clip
            <div className='clip-show'>
              <div className='desc'>
                这个步骤包含一些示例附件 <br/>
                请点击下面的条目来观看：
              </div>
              <TellerClipList cids={action.clip_ids} />
            </div>

          else
            <div />

        desc_show = 
          <div className='desc-show'>
            <h4>操作概述：</h4>
            <div>
            <SimpleFormatText text={action.desc} placeholder='需要熟悉业务的人员填写' />
            </div>
          </div>

        <div className={klass.join(' ')}>
          <div ref='box'>
            {action_name}
            <div className='scroller'>
              {screen_show}
              {clip_show}
              {desc_show}
            </div>
            {nav}
          </div>
        </div>

      show: (action)->
        $box = jQuery React.findDOMNode @refs.box
        $box.find('.ct').fadeOut 100, =>
          @setState action: action

      componentDidUpdate: ->
        $box = jQuery React.findDOMNode @refs.box
        $box.find('.ct').fadeIn(100)

      focus_prev: ->
        if @has_prev
          @props.oep.focus_action @state.action.pre_actions[@prev_keys[0]]

      focus_next: ->
        if @has_next
          @props.oep.focus_action @state.action.post_actions[@next_keys[0]]

      show_question_modal: ->
        jQuery.open_modal(
          <WareQuestionModal ware={@props.ware} />, {
            closable: false
          }
        )

      show_note_modal: ->
        jQuery.open_modal(
          <WareNoteModal ware={@props.ware} />, {
            closable: false
          }
        )

# -------------------------------------
# 以下是非 ReactJS 的类，用于数据解析
# 和课程编辑器中的类应该复用，将来重构


class OEActionsGraph
  constructor: (raw_data)->
    @roles = {}
    @actions = {}

    # 第一次遍历，实例化 action 对象
    # 分角色提取 action 集合
    for id, _action of raw_data.actions
      action = new OEAction _action, @
      role = action.role
      @roles[role] ||= {}
      @roles[role][action.id] = action
      @actions[id] = action

    # 第二次遍历，给每个 action 对象的前置后续操作赋值
    for id, action of @actions
      for post_action_id in action.post_action_ids
        post_action = @actions[post_action_id]
        if post_action?
          action.post_actions[post_action.id] = post_action
          post_action.pre_actions[action.id] = action

    # 第三次遍历，划分子连通图
    @sub_graphs = []
    for id, action of @actions
      sub_graph = new OEActionsSubGraph
      @_r_sub_graph action, sub_graph
      @sub_graphs.push sub_graph if not sub_graph.is_empty()

    # 分别遍历各个子图
    # 计算各个节点深度值 (deep)
    # 和偏移值 (offset)
    offset_deep = 0
    for sub_graph in @sub_graphs
      sub_graph.offset_deep = offset_deep
      sub_graph.compute()
      offset_deep = offset_deep + sub_graph.max_deep + 1

    # 课件绘制的补充需求
    # 再次遍历所有子图，计算节点视觉深度值（vdeep）
    # 以达到更美观紧凑的显示
    for sub_graph in @sub_graphs
      sub_graph.compute_vdeep()


  _r_sub_graph: (action, sub_graph)->
    return if action.sub_graph?
    action.sub_graph = sub_graph
    sub_graph.add(action)
    for id, pre_action of action.pre_actions
      @_r_sub_graph pre_action, action.sub_graph
    for id, post_action of action.post_actions
      @_r_sub_graph post_action, action.sub_graph

  draw_animate_arrow: (role_pos)->
    @arrow_offset = 0 if not @arrow_offset?
    requestAnimationFrame =>
      @draw_arrow role_pos
      @arrow_offset += 0.5
      # console.log @arrow_offset
      @draw_animate_arrow role_pos

  draw_arrow: (role_pos)->
    $ncanvas = jQuery('canvas.ncanvas')
    $nbox = jQuery('.nbox')

    if not @curve_arrow?
      $ncanvas
        .attr 'width', $nbox.width()
        .attr 'height', $nbox.height()

      @curve_arrow = new CurveArrowA $ncanvas[0]

    @curve_arrow.clear()

    for id, action of @actions
      if action.is_start()
        @_r_arrow action, role_pos

  _r_arrow: (action, role_pos)->
    # 画箭头
    for id, post_action of action.post_actions
      x0 = action.css_pos().left + OEAction.CSS_WIDTH / 2
      y0 = action.css_pos().top + OEAction.CSS_HEIGHT / 2
      x1 = post_action.css_pos().left + OEAction.CSS_WIDTH / 2
      y1 = post_action.css_pos().top + OEAction.CSS_HEIGHT / 2

      action_offset = role_pos[action.role]
      post_action_offset = role_pos[post_action.role]

      x0 += action_offset.left
      x1 += post_action_offset.left

      @curve_arrow.draw x0, y0, x1, y1, '#999999', @arrow_offset
      @_r_arrow post_action, role_pos


class OEActionsSubGraph
  constructor: ->
    @actions = {}
    @offset_deep = 0
    @max_deep = 0

  add: (action)->
    @actions[action.id] = action

  is_empty: ->
    Object.keys(@actions).length is 0

  compute: ->
    @deeps = {}
    for id, action of @actions
      if action.is_start()
        @_r action, 0

    for role, role_deeps of @deeps
      for deep, actions of role_deeps
        idx = 0
        for id, action of actions
          action.offset = idx
          idx += 1

  _r: (action, deep)->
    deep_role = @deeps[action.role] ||= {}

    if not action.deep?
      action.deep = deep
      deep_role[deep] ||= {}
      deep_role[deep][action.id] = action

    if deep > action.deep
      delete deep_role[action.deep][action.id]
      action.deep = deep
      deep_role[deep] ||= {}
      deep_role[deep][action.id] = action

    @max_deep = action.deep if action.deep > @max_deep
    for id, post_action of action.post_actions
      @_r post_action, deep + 1

  compute_vdeep: ->
    for id, action of @actions
      if action.is_start()
        @_rv action

  _rv: (action)->
    @_adjust_vdeep action

    for id, post_action of action.post_actions
      @_rv post_action

  _adjust_vdeep: (action)->
    action.vdeep = action.deep
    same_role_deep_actions = @deeps[action.role][action.deep]
    
    # 没有同角色的同深度节点时才需要调整
    return if Object.keys(same_role_deep_actions).length > 1

    # 有父节点时才需要调整
    return if Object.keys(action.pre_actions).length == 0
    
    # 获取所有父节点的最大深度
    max_pre_vdeep = 0
    for id, pre_action of action.pre_actions
      max_pre_vdeep = Math.max max_pre_vdeep, pre_action.vdeep

    # 获取同角色节点的小于当前节点的最大深度
    _actions = (_action for id, _action of @actions).filter (x)->
      x.vdeep < action.deep and x.role == action.role
    max_same_role_vdeep = -1
    for _action in _actions
      max_same_role_vdeep = Math.max max_same_role_vdeep, _action.vdeep

    # console.log action.name, max_pre_vdeep, max_same_role_vdeep
    action.vdeep = Math.max max_pre_vdeep, max_same_role_vdeep + 1


class OEAction
  @CSS_WIDTH: 180
  @CSS_HEIGHT: 70
  @CSS_GAP: 30

  constructor: (_action, @graph)->
    @id = _action.id
    @role = _action.role
    @name = _action.name
    @post_action_ids = _action.post_action_ids || []
    @post_actions = {}
    @pre_actions = {}
    @screen_ids = _action.linked_screen_ids || []
    @clip_ids = _action.linked_clip_ids || []
    @desc = _action.desc || ''
    @business_kind_str = _action.business_kind_str

    @deep = null
    @offset = 0

  is_start: ->
    Object.keys(@pre_actions).length is 0

  is_end: ->
    Object.keys(@post_actions).length is 0

  css_pos: ->
    top = 
      OEAction.CSS_GAP + 
      # (@deep + @sub_graph.offset_deep) * 
      (@vdeep + @sub_graph.offset_deep) * 
      (OEAction.CSS_HEIGHT + OEAction.CSS_GAP)
    
    bottom = top + OEAction.CSS_HEIGHT
    left = OEAction.CSS_GAP + @offset * (OEAction.CSS_WIDTH + OEAction.CSS_GAP)
    right = left + OEAction.CSS_WIDTH

    top: top
    left: left
    bottom: bottom
    right: right