@ExerciseCodePage = React.createClass
  next: (answer)->
    right = @state.question_right
    right += 1 if @state.question.answer == answer
    @setState
      question_index: @state.question_index + 1
      question: @props.data.questions[@state.question_index + 1]
      question_right: right

  getInitialState: ->
    question_index: 0
    question_right: 0
    question: @props.data.questions[0]

  render: ->
    params =
      data: @props.data
      question: @state.question
      next: @next
      question_index: @state.question_index
      question_right: @state.question_right
      label: "交易码"

    <ExerciseBase {...params}>
      <div>
        {
          @state.question.content
        }
      </div>

    </ExerciseBase>


