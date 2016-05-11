@ManagerQuestionsPage = React.createClass
  render: ->
    <div className='manager-question-page'>
      <ManagerQuestionsPage.Table {...@props} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            asker: '提问人'
            position: '提问位置'
            created_at: '提问时间'
            answers_count: '回答数目'
            title: '问题'
            ops: ''
          data_set: @props.data.questions.map (q)->
            q.ops = 
              <div>
                <a href='javascript:;' className='ui button mini basic'>查看</a>
              </div>
            q

          th_classes: {
            answers_count: 'collapsing'
            asker: 'collapsing'
          }
          td_classes: {
            created_at: 'collapsing'
            position: 'collapsing'
            ops: 'collapsing'
          }
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='开课管理' />
        </div>