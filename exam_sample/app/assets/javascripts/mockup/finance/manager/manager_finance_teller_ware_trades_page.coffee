@ManagerFinanceTellerWareTradesPage = React.createClass
  getInitialState: ->
    trades: @props.data.trades
    paginate: @props.data.paginate
    search: @props.data.search || ''

  render: ->
    <div className='manager-bank-teller-wares'>
      <ManagerFinanceTellerWareTradesPage.Table data={@state} page={@} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            number: '业务代码'
            jydm: '关联交易代码'
            jymc: '交易名称'
            xh: '序号'
            input_screen_hmdms: '输入画面'
            response_screen_hmdm: '响应画面'
            compound_screen_hmdm: '结算画面'

          data_set: @props.data.trades.map (x)=>
            jQuery.extend x, {
              input_screen_hmdms:
                <div>
                {
                  for hmdm in x.input_screen_hmdms
                    <TellerScreenButton key={hmdm} hmdm={hmdm} />
                }
                </div>
              response_screen_hmdm:
                if x.response_screen_hmdm?
                  <TellerScreenButton hmdm={x.response_screen_hmdm} />
              compound_screen_hmdm:
                if x.compound_screen_hmdm?
                  <TellerScreenButton hmdm={x.compound_screen_hmdm} />
            }
          th_classes:
            number: 'collapsing'
            jydm: 'collapsing'
            xh: 'collapsing'
          td_classes:
            jymc: 'collapsing'
          paginate: @props.data.paginate
          search: @props.data.search
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='关联交易' />
        </div>