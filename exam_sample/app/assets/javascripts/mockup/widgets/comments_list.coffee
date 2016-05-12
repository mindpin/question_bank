@CommentsList = React.createClass
  render: ->
    <div className='comments-list'>
      <div className='ui comments'>
        <div className='ui reply form'>
          <div className='field'>
            <textarea className='text-ipt' placeholder='写点什么吧…'></textarea>
          </div>
          <div className='btns'>
            <div className='ui blue labeled submit icon button tiny'>
              <i className='icon edit'></i>
              发评论 
            </div>
          </div>
        </div>

      {
        for comment, idx in @props.data
          <div key={idx} className='comment'>
            <a className='avatar'><img src={comment.author.avatar} /></a>
            <div className='content'>
              <a className='author'>{comment.author.name}</a>
              <div className='metadata'>
                <span className='data'>{comment.date}</span>
              </div>
              <div className='text'>{comment.content}</div>
            </div>
          </div>
      }
      </div>
    </div>