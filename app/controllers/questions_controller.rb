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
    @is_teacher = Lesson.find_by(:id => id).user_lessons.find_by(:user_id => current_user.id, :lesson_id => id).is_teacher
  end

  def show
    @question = Question.find(params[:id])
    id = params[:lesson_id] || 1
    @latest_answer = Answer.latest_answer(:student_id => current_user.id,
                                          :question_id => params[:id],
                                          :lesson_id => id) || Answer.new
    @is_teacher = Lesson.find_by(:id => id).user_lessons.find_by(:user_id => current_user.id, :lesson_id => id).is_teacher
  end

end
