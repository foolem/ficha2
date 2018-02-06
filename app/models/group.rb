class Group < ApplicationRecord
  belongs_to :matter
  belongs_to :semester
  belongs_to :course, optional: true

  has_one :ficha
  has_and_belongs_to_many :schedules
  belongs_to :option, optional: true
  belongs_to :unite_group, optional: true

  def code_with_group
    "#{name} - #{matter.code}"
  end

  def group_with_code
    "#{matter.code}-#{name}"
  end

  def code_with_group_show
    "#{matter.code} - #{name}"
  end

  def code_with_group_and_name
    "#{name} -  #{matter.code} - #{matter.name}"
  end

  def name_with_course
    "#{name} - #{course.name}"
  end

  def code_name_and_course
    "#{matter.code} #{name_with_course}"
  end

  def has_unite?
    !unite_group.blank?
  end

  def has_ficha?
    !ficha.blank?
  end

  def same_groups
    if schedules.length == 0
      return [self]
    end


    result = []
    groups = []

    if !matter.unite_matter.blank? #se existe uma união de matérias
      matter.unite_matter.matters.each do |matter| #faz um each para cada matéria dessa união
        matter.groups.each do |grp| #para cada turma de uma matéria dessa união
          if grp.semester = semester #se o semestre dessa turma for igual ao semester
            groups << grp
          end
        end
      end
    else
      groups = matter.groups
    end

    groups.each do |grp|
      if schedules == grp.schedules && semester == Semester.current_semester && grp.semester == Semester.current_semester
        result << grp
      end
    end

    result
  end

end
