class User < ApplicationRecord
    has_many :students, foreign_key: :user_id, class_name: 'Enrollment'
    has_many :teachers, foreign_key: :teacher_id, class_name: 'Enrollment'
    has_many :favorite_teachers, through: :students, source: :teacher, class_name: 'User'

    enum kind: { student: 0, teacher: 1, student_teacher: 2 }

    before_update :valiate_kind

    def valiate_kind
        if kind_changed? && student_or_teacher_exists? && (kind == "teacher" || kind == "student")
            errors.add(:base, "Kind can not be #{kind} because is teaching in at least one program") if kind == "student" 
            errors.add(:base, "Kind can not be #{kind} because is studying in at least one program") if kind == "teacher" 
            throw :abort
          end
    end

    def self.classmates(user)
      where(id: enrolled_teachers(user)).where.not(id: user.id)
    end

    def self.fetch_favourate_teacher(user)
        where(id: Enrollment.joins(:user)
                            .where(users: { id: user.id }, favorite: true)
                            .pluck(:teacher_id))

    end

    private

    def student_or_teacher_exists?
        students.exists? || teachers.exists?
    end

    def self.fetch_teachers(user)
        Enrollment.where(user: user).distinct.pluck(:teacher_id)
    end

    def self.enrolled_teachers(user)
        Enrollment.where(teacher_id: fetch_teachers(user)).distinct.pluck(:user_id)
    end
end
