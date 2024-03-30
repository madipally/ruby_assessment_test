require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  describe "validations" do
    let(:user) { User.create(name: "Naveen", kind: :student, age: 21) }
    let(:teacher) { User.create(name: "Anand", kind: :teacher, age: 31) }
    let(:program) { Program.create(name: "Math") }

    it "ensures that a user can enroll to a teacher only once for a particular program" do
      enrollment1 = Enrollment.create(user: user, teacher: teacher, program: program)
      enrollment2 = Enrollment.new(user: user, teacher: teacher, program: program)
      expect(enrollment2).not_to be_valid
      expect(enrollment2.errors[:user_id]).to include("has already enrolled to this teacher and for this program")
    end

    it "allows enrollment if user and teacher combination is unique" do
      enrollment1 = Enrollment.create(user: user, teacher: teacher, program: program)
      user2 = User.create(name: "Praveen", kind: :student, age: 23)
      enrollment2 = Enrollment.new(user: user2, teacher: teacher, program: program)
      expect(enrollment2).to be_valid
    end
  end
end
