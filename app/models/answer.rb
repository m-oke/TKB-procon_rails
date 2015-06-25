class Answer < ActiveRecord::Base
  belongs_to :user, :foreign_key => :student_id
  belongs_to :question, :foreign_key => :question_id
  belongs_to :lesson, :foreign_key => :lesson_id

  EXT = {"c" => ".c", "python" => ".py"}
  RESULT = {-1 => "Reject", 0 => "Pending", 1 => "Accept"}


  def self.latest_answer(student_id: , lesson_id: ,question_id: )
    answers = Answer.where(:student_id => student_id,
                           :question_id => question_id,
                           :lesson_id => lesson_id)
    latest_answer = nil
    unless answers.empty?
      last = answers.where(:result => 1).last
      latest_answer = last.nil? ? answers.last : last
    end
    return latest_answer
  end

end
