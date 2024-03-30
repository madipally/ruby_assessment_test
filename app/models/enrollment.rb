class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :program
  belongs_to :teacher, foreign_key: :teacher_id, class_name: 'User'
  belongs_to :student, foreign_key: :user_id, class_name: 'User'

  validates :user_id, uniqueness: { scope: :teacher_id && :program_id, message: "has already enrolled to this teacher and for this program" }
end
