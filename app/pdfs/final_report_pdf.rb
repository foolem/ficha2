class FinalReportPdf < Prawn::Document

  include GroupsHelper
  include SchedulesHelper

  def initialize(semester)

    super(top_margin: 20, :page_size => "A4", :page_layout => :landscape)
    @margem = 50
    @number = 0
    if semester.blank?
      current_groups.each_with_index do |group, i|
        if i == 1
          @semester = get_semester(group)
          break
        end
      end
    else
      @semester = Semester.find(semester)
    end
    record_generate
  end

  def get_rows
    rows = []
    rows.push ["Código", "Turma", "Disciplina", "Horário", "Nº Alunos", "Sala", "Curso", "Professor"]

    selected_groups(@semester.id).each_with_index do |group, i|

      rows.push [get_code(group), get_classes(group), get_matter(group), get_schedule(group),
                get_vacancies(group), get_classroom(group), get_course(group), get_teacher(group)]

    end
    rows
  end

  def get_code(group)
    code = group.matter.code
    code
  end

  def get_classes(group)
    classes = group.name
    classes
  end

  def get_matter(group)
    matter = group.matter.name
    matter
  end

  def get_schedule(group)

    schedule_list = {}

    group.schedules.distinct.each do |schedule|
      item = "#{schedule.begin.strftime("%H:%M")} - #{schedule.end.strftime("%H:%M")}"
      if !schedule_list[item].blank?
        schedule_list[item] = schedule_list[item] + [schedule.day_to_i + 1]
      else
        schedule_list[item] = [schedule.day_to_i + 1]
      end
    end
    result = schedule_list.map do |key, value|
      days = value.collect { |v| "#{v}a"  }.join(", ")
      "#{days} #{key}"
    end

    return result.join(" e ")
  end

  def get_vacancies(group)
    vacancies = group.vacancies
    vacancies
  end

  def get_classroom(group)
    classroom = group.class_room
    classroom
  end

def get_course(group)
    course = group.course.name
    course
  end

  def get_teacher(group)
    owner = group.ficha.blank? ? " " : group.ficha.user.name
    owner
  end

  def record_generate
    text  @semester.semester_with_year_show, size: 14, style: :bold, align: :center
    move_down 15

    table_data = get_rows
    table(table_data, header: true, cell_style: {size: 11}, column_widths: [60,45,160,130,50,50,120,150], position: 5) do
      row(0).style font_style: :bold, align: :center
    end

  end


  def get_semester(group)
    return group.semester
  end

end
