# -*- coding: utf-8 -*-
class QuestionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    id = params[:lesson_id] || 1
    @lesson = Lesson.find_by(:id => id)
    unless @lesson.nil?
      if UserLesson.find_by(:user_id => current_user.id, :lesson_id => id).nil?
        redirect_to root_path, :alert => "該当する授業に参加していません．"
      end
      @questions = @lesson.question
    else
      redirect_to root_path, :alert => "該当する授業が存在しません。"
    end
  end

  def show
    @question = Question.find(params[:id])
    answers = Answer.where(:student_id => current_user.id,
                           :question_id => params[:id],
                           :lesson_id => params[:lesson_id])
    @latest_answer = Answer.new
    unless answers.empty?
      last = answers.where(:result => 1).last
      @latest_answer = last.nil? ? answers.last : last
    end
  end

end
