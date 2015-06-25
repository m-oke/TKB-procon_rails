class Answer < ActiveRecord::Base
  belongs_to :user, :foreign_key => :student_id
  belongs_to :question, :foreign_key => :question_id
  belongs_to :lesson, :foreign_key => :lesson_id

  EXT = {"c" => ".c", "python" => ".py"}
  RESULT = {-1 => "Reject", 0 => "Pending", 1 => "Accept"}
end
