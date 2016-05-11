@ManagerFinanceTellerWareScreensPage = React.createClass
  getInitialState: ->
    screens: @props.data.screens
    paginate: @props.data.paginate
    search: @props.data.search || ''

  render: ->
    <div className='manager-bank-teller-wares'>
      <ManagerFinanceTellerWareScreensPage.Table data={@state} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            hmdm: '画面代码'
            zds_count: '字段数目'
            ops: '预览'
            edit: '编辑数据'
          data_set: @props.data.screens.map (x)=>
            jQuery.extend x, {
              zds_count: x.zds.length
              ops:
                <TellerScreenButton hmdm={x.hmdm} />
              edit:
                <a href={x.edit_sample_data_url} className='ui basic button mini'>
                  <i className='icon configure' /> 编辑数据
                </a>
            }
          th_classes:
            hmdm: 'collapsing'
            zds: 'zds'
          td_classes:
            ops: 'collapsing'
            edit: 'collapsing'
          paginate: @props.data.paginate
          search: @props.data.search
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='模拟屏幕清单' />
        </div>