# -*- coding: utf-8 -*-
class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :questions, :students]
  before_filter :authenticate_user!

  def show
    @teachers = get_teachers
  end

  def students
    @students = get_students
  end

  private
  def set_lesson
    @lesson = Lesson.find_by(:id => params[:id])
    if @lesson.nil?
      redirect_to root_path, :alert => "該当する授業が存在しません。"
    end
  end

  def get_students
    return User.where(:id => @lesson.user_lessons.where(:is_teacher => false).pluck(:user_id))
  end

  def get_teachers
    return User.where(:id => @lesson.user_lessons.where(:is_teacher => true).pluck(:user_id))
  end

end
