# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# root
User.create(:name => "root1", :nickname => "root", # :faculty => "研究科1", :department => "工学域1", :grade => 0,
            :email => "root@user.com", :password => "testtest", :roles => [:root, :admin, :teacher, :student])

# 管理者
2.times do |i|
  User.create(:name => "管理者#{i + 1}", :nickname => "admin#{i+1}", # :faculty => "研究科1", :department => "工学域1", :grade => 0,
             :email => "Admin#{i + 1}@user.com", :password => "testtest", :roles => [:admin, :teacher, :student])
end


# 教師
3.times do |i|
    User.create(:name => "教員#{i + 1}", :nickname => "teacher#{i+1}", # :faculty => "工学域#{i + 1}", :department => "工学域#{i + 1}", :grade => 0,
                :email => "teacher#{i + 1}@user.com", :password => "testtest", :roles => [:teacher, :student])
end

# 学生
20.times do |i|
  if i < 9
    x = "0#{i + 1}"
  else
    x = "#{i + 1}"
  end
  User.create(:student_number => "2015200#{x}", :name => "学生#{i + 1}", :nickname => "student#{i+1}", #:faculty => "学部#{(i + 1) % 3 + 1}", :department => "学科#{(i + 1) % 2 + 1}", :grade => ((i + 1) % 4),
              :email => "student#{i + 1}@user.com", :password => "testtest", :roles => [:student])
end

# クラス
# すべての問題を含む，全員が参加するクラス
Lesson.create(:name => "All probrems", :description => "このクラスはすべての問題を含むクラスです。", :lesson_code => "0000000000")
# 授業コード 1010101, 1010102
2.times do |i|
  Lesson.create(:name => "講義#{i + 1}", :description => "説明#{i + 1}", :lesson_code => "101010#{i+1}")
end

# ユーザ:クラス
# すべての問題を含むクラス
UserLesson.create(:user_id => 1, :lesson_id => 1, :is_teacher => true)
25.times do |i|
  UserLesson.create(:user_id => i + 2, :lesson_id => 1, :is_teacher => false)
end

# 教師
2.times do |i|
  UserLesson.create(:user_id => i + 4, :lesson_id => i + 2, :is_teacher => true)
end

# 学生(user_id: 7~26)
15.times do |i|
  if i / 8 == 0
    UserLesson.create(:user_id => i + 7, :lesson_id => 2) # id:7~14
  else
    UserLesson.create(:user_id => i + 7, :lesson_id => 3) # id:15~21
  end
end

# 問題
# 過去の問題
Question.create(:title => "問題1", :content => "問題1の内容", :input_description => "問題1の入力説明", :output_description => "問題1の出力説明",  :run_time_limit => 5, :memory_usage_limit => 256, :cpu_usage_limit => 50)

# 現在の問題
Question.create(:title => "問題2", :content => "問題2の内容", :input_description => "問題2の入力説明", :output_description => "問題2の出力説明",  :run_time_limit => 5, :memory_usage_limit => 256, :cpu_usage_limit => 50)

# 未来の問題
Question.create(:title => "問題3", :content => "問題3の内容", :input_description => "問題3の入力説明", :output_description => "問題3の出力説明",  :run_time_limit => 5, :memory_usage_limit => 256, :cpu_usage_limit => 50)

# 問題とクラスの割当
3.times do |i|
  LessonQuestion.create(:lesson_id => 1, :question_id => i + 1)
end

#それぞれのクラス
LessonQuestion.create(:lesson_id => 2, :question_id => 1, :start_time => (Date.today - 7).to_s, :end_time => (Date.today - 1).to_s)
LessonQuestion.create(:lesson_id => 2, :question_id => 2, :start_time => (Date.today - 3).to_s, :end_time => (Date.today + 4).to_s)
LessonQuestion.create(:lesson_id => 2, :question_id => 3, :start_time => (Date.today + 7).to_s, :end_time => (Date.today + 10).to_s)

# 入出力サンプル
Sample.create(:question_id => 1, :input => "1 2 3", :output => "6")
Sample.create(:question_id => 1, :input => "2 3 4", :output => "9")
Sample.create(:question_id => 2, :input => "2", :output => "1")
Sample.create(:question_id => 2, :input => "5", :output => "1")
Sample.create(:question_id => 3, :input => "10", :output => "30")

# テストデータ
TestDatum.create(:question_id => 1, :input => "1 2 3", :output => "6")
TestDatum.create(:question_id => 1, :input => "2 3 4", :output => "9")
TestDatum.create(:question_id => 1, :input => "10 50 100", :output => "160")
TestDatum.create(:question_id => 2, :input => "2", :output => "1")
TestDatum.create(:question_id => 2, :input => "5", :output => "1")
TestDatum.create(:question_id => 2, :input => "100", :output => "1")
TestDatum.create(:question_id => 3, :input => "10", :output => "30")
TestDatum.create(:question_id => 3, :input => "2", :output => "6")
TestDatum.create(:question_id => 3, :input => "121", :output => "363")


# 回答
# 学生1
Answer.create(:student_id => 7, :lesson_id => 2, :question_id => 1, :file_name => "version1.txt", :language => "c", :result => -1, :plagiarism_percentage => 0.4)
Answer.create(:student_id => 7, :lesson_id => 2, :question_id => 1, :file_name => "version2.txt", :language => "c", :result => -1, :plagiarism_percentage => 0.4)
Answer.create(:student_id => 7, :lesson_id => 2, :question_id => 1, :file_name => "version3.txt", :language => "c", :result => 1, :run_time => 1, :memory_usage => 10, :cpu_usage => 7, :plagiarism_percentage => 0.4)
Answer.create(:student_id => 7, :lesson_id => 2, :question_id => 1, :file_name => "version4.txt", :language => "c", :result => 1, :run_time => 0.1, :memory_usage => 5, :cpu_usage => 7, :plagiarism_percentage => 0.9)

Answer.create(:student_id => 7, :lesson_id => 2, :question_id => 2, :file_name => "version1.txt", :language => "c", :result => 1, :run_time => 0.1, :memory_usage => 5, :cpu_usage => 7, :plagiarism_percentage => 0.1)


# 学生2
Answer.create(:student_id => 8, :lesson_id => 2, :question_id => 1, :file_name => "version1.txt", :language => "c", :result => -1, :plagiarism_percentage => 0.1)

Answer.create(:student_id => 8, :lesson_id => 2, :question_id => 2, :file_name => "version1.txt", :language => "c", :result => -1, :plagiarism_percentage => 0.2)
Answer.create(:student_id => 8, :lesson_id => 2, :question_id => 2, :file_name => "version2.txt", :language => "c", :result => 1, :run_time => 1, :memory_usage => 10, :cpu_usage => 8, :plagiarism_percentage => 0.5)

# クラス1の残りの学生
(9..14).each do |i|
  Answer.create(:student_id => i, :lesson_id => 2, :question_id => 1, :file_name => "version1.txt", :language => "c", :result => 1, :run_time => 3, :memory_usage => 50, :cpu_usage => 10, :plagiarism_percentage => 0.3)
end
