module QuestionBank
  class QuestionsController < QuestionBank::ApplicationController
    include QuestionBank::ApplicationHelper
    def new_single_choice
      _new("single_choice")
    end

    def new_multi_choice
      _new("multi_choice")
    end

    def new_bool
      _new("bool")
    end

    def new_mapping
      _new("mapping")
    end

    def new_essay
      _new("essay")
    end

    def new_fill
      _new("fill")
    end

    def index
      params[:page] ||= 1
      @questions = Question.page(params[:page]).per(6)
    end

    def create
      kind = params[:question][:kind]
      hash = send("question_#{kind}_params")
      @question = Question.new(hash)
      if @question.save
        redirect_to questions_path
      else
        render "new_#{kind}"
      end
    end

    def edit
      @question = Question.find(params[:id])
      @kind = @question.kind
      render "new_#{@kind}"
    end

    def update
      @question = Question.find(params[:id])
      @kind = @question.kind
      hash = send("question_#{@kind}_params")
      if @question.update_attributes(hash)
        redirect_to "/questions"
      else
        render "new_#{@kind}"
      end
    end

    def destroy
      @question = Question.find(params[:id])
      @question.destroy
      redirect_to "/questions"
    end

    def do_question
      p '_____'
      if params[:redo_id].present?
        @length = 1
        @questions_array = QuestionFlaw.find(params[:redo_id]).question.to_a
        form_html = render_to_string :partial => 'do_question',locals: { questions_array: @questions_array ,length: 1,index: 0} 
        render :json => {
        :status => 200,
        :body => form_html
        }
      else
        @questions_array = Question.all.to_a
        params[:questions_array_index] ||= 0
        @index = params[:questions_array_index].to_i
        @length = @questions_array.length
      end
    end

    def do_question_validation
      kind = params[:kind]
      answer = params[:answer]
      question_id = params[:answer_id]
      case kind
        when 'fill' then
          _fill_validation(answer,question_id)
        when 'bool' then
          _bool_validation(answer,question_id)
        when 'mapping' then
          _mapping_validation(answer,question_id)
        when 'single_choice' then
          _single_choice_validation(answer,question_id)
        when 'multi_choice' then
          _multi_choice_validation(answer,question_id)
        when 'essay' then
          _essay_without_validation(answer,question_id)
      end
    end

    def search
      @type = params[:type]
      @kind = params[:kind]
      @min_level = params[:min_level].to_i
      @max_level = params[:max_level].to_i
      @per = params[:per].to_i
      @per = 5 if @per <= 0
      case @type
      when 'random'
        questions = Question.where(kind: @kind, level: @min_level..@max_level)
        count = questions.count
        @questions = (0..count-1).sort_by{rand}.slice(0, @per).collect! do |i| questions.skip(i).first end
      when 'select'
        # 显示所有题目
        @questions = Question.where(kind: @kind, level: @min_level..@max_level)
      else
        @questions = Question.where(kind: @kind, level: @min_level..@max_level).page(params[:page]).per(@per)
      end
      render json: @questions.map{ |question|
        {
          id: question.id.to_s,
          content: question.content
        }
      }
    end

    private
      def make_record(kind,answer,question_id,wrong_msg)
        if wrong_msg.length == 0
          p '正确'
          flaw = QuestionBank::QuestionRecord.new(:user=>current_user,:questions=>QuestionBank::Question.find(question_id),:is_correct=>true,"#{kind}_answer"=>answer)                    
          p flaw.valid?
          p flaw.errors
          flaw.save
        else
          p '错误'
          p answer.class
          flaw = QuestionBank::QuestionRecord.new(:user=>current_user,:questions=>QuestionBank::Question.find(question_id),:is_correct=>false,"#{kind}_answer"=>answer)
          p flaw.valid?
          p flaw.errors
          flaw.save
        end
      end

      def _essay_without_validation(content,question_id)
        wrong_msg =[]
        make_record("essay",content,question_id,wrong_msg)
      end

      def _fill_validation(array,question_id)
        query_right_answer = Question.find(question_id).fill_answer
        wrong_information = []
        0.upto(query_right_answer.length-1).each do |i|
          if query_right_answer[i] != array[i]
            wrong_information.push({:index=>i,:right_answer=>query_right_answer[i]})
          end
        end
        render :json => {:information => wrong_information}.to_json
        make_record("fill",array,question_id,wrong_information)
      end

      def _bool_validation(answer,question_id)
        query_right_answer = Question.find(question_id).bool_answer
        wrong_information=[]
        if query_right_answer.to_s!=answer
          wrong_information.push(query_right_answer)
        end
        if answer == 'true'
          answer_flaw = true
        else
          answer_flaw = false
        end
        render :json => {:information => wrong_information}.to_json
        make_record("bool",answer_flaw,question_id,wrong_information)
      end

      def _single_choice_validation(answer,question_id)
        wrong_information = []
        query_right_answer = Question.find(question_id).choice_answer
        right_option = query_right_answer.select{|x| x[1]==true}.first
        query_right_answer.each_with_index do |right_answer,index|
          if right_answer[0] == answer
            if right_answer[1] == true
              wrong_information = []
              break;
            else
              wrong_information.push(right_option)
            end
          end
        end
        render :json => {:information => wrong_information}.to_json
        answer_flaw_format = query_right_answer.map do |option|
          if option[0] == answer
            [option[0],true]
          else
            [option[0],false]
          end
        end
        # 制作标准答案格式
        make_record("choice",answer_flaw_format,question_id,wrong_information)
      end

      def _multi_choice_validation(answer,question_id)
        wrong_information = []
        query_right_answer = Question.find(question_id).choice_answer
        p answer
        p '正确的答案'
        p query_right_answer
        query_right_answer_true_option = query_right_answer.select{|x| x[1] ==true}
        p query_right_answer_true_option
        answer = answer.to_a.map do |a|
          a[1]
        end
        answer= answer.map do |a| 
          if a[1] =='true'
            [a[0],true]
          else
            [a[0],false]
          end
        end
        p '加工后的 做的答案'
        p answer
        query_right_answer.each_with_index do |right_answer,index|
          p right_answer[1]
          p answer[index][1]
          if right_answer[1] != answer[index][1]
            wrong_information.push({:index=>index,:right_answer=>right_answer})
          end
        end
        p wrong_information
        render :json => {:information => wrong_information,:checked_option=>query_right_answer_true_option}.to_json
        make_record("choice",answer,question_id,wrong_information)
      end

      def _mapping_validation(answer,question_id)
        wrong_information = []
        query_right_answer = Question.find(question_id).mapping_answer 
        answer = answer.to_a.map do |a|
          a[1]
        end
        query_right_answer.each_with_index do |right_answer,index|
          if right_answer[1].to_s != answer[index][1]
            wrong_information.push({:index=>index,:right_answer=>right_answer})
          end
        end
        p '##############'
        p answer
        p wrong_information
        make_record("mapping",answer,question_id,wrong_information)
        render :json => {:information => wrong_information,:right_option=>query_right_answer}.to_json
      end


      def _new(kind)
        @question = Question.new(:kind => kind)
      end


      def question_bool_params
        params.require(:question).permit(:kind, :content, :bool_answer, :analysis, :level, :enabled)
      end

      def question_single_choice_params
        params.require(:question).permit(:kind, :content, :analysis, :level, :enabled, :choices => [], :choice_answer_indexs => [])
      end

      def question_multi_choice_params
        params.require(:question).permit(:kind, :content, :analysis, :level, :enabled, :choices => [], :choice_answer_indexs => [])
      end

      def question_fill_params
        params.require(:question).permit(:kind, :content, :analysis, :level, :enabled, :fill_answer => [])
      end

      def question_mapping_params
        new_mapping_answer = []
        params[:question][:mapping_answer].each { |key,value| new_mapping_answer[key.to_i] = value}
        hash = params.require(:question).permit(:kind, :content, :analysis, :level, :enabled)
        hash[:mapping_answer] = new_mapping_answer
        hash
      end

      def question_essay_params
        params.require(:question).permit(:kind, :content, :analysis, :essay_answer, :level, :enabled)
      end
  end
end
