@FinanceTellerWareCard = React.createClass
  render: ->
    ware = @props.data
    <div className='teller-ware-card card ware'>
      <div className='content'>
        <div className='right floated mini ui image'>
          <div className='ic'>
            <i className='icon rmb' />
          </div>
        </div>
        <div className='header number'>
          {ware.number}
        </div>
        <div className='meta name'>
          {ware.name}
        </div>
      </div>
      <div className='extra content'>
        <a className='ui basic button fluid pill' href={ware.show_url} target='_blank'>
          学　习
        </a>
      </div>
    </div>