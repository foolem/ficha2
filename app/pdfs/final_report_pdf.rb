class FinalReportPdf < Prawn::Document

  include GroupsHelper
  include SchedulesHelper

  def initialize()
    super(top_margin: 20, :page_size => "A4", :page_layout => :landscape)
    @margem = 50
    @number = 0

    record_generate
  end

  def get_rows
    rows = []
    rows.push ["Código", "Turma", "Disciplina", "Horário", "Nº Alunos", "Sala", "Curso", "Professor"]

    current_groups.each_with_index do |group, i|

      if group.matter.code == "CM041" && group.name == "B" && group.course.name == "Matemática Industrial"
        group.vacancies = group.vacancies + 60
        group.course.name = group.course.name + ", Engenharia Industrial Madeireira Diurno"
      end
      if group.matter.code == "CM041" && group.name == "C" && group.course.name == "Engenharia Industrial Madeireira Diurno"
        i = "a"
      end

      if group.matter.code == "CM043" && group.name == "C" && group.course.name == "Engenharia Civil"
        group.vacancies = group.vacancies + 5
        group.course.name = group.course.name + ", Ciência da Computação"
      end
      if group.matter.code == "CM043" && group.name == "C" && group.course.name == "Ciência Da Computação"
        i = "a"
      end

      if group.matter.code == "CM043" && group.name == "D" && group.course.name == "Licenciatura em Química Noturno"
        group.vacancies = group.vacancies + 20
        group.course.name = group.course.name + ", Matemática Industrial"
      end
      if group.matter.code == "CM043" && group.name == "D" && group.course.name == "Matemática Industrial"
        i = "a"
      end

      if group.matter.code == "CM044" && group.name == "B" && group.course.name == "Física Noturno"
        group.vacancies = group.vacancies + 15
        group.course.name = group.course.name + ", Matemática Industrial"
      end
      if group.matter.code == "CM044" && group.name == "B" && group.course.name == "Matemática Industrial"
        i = "a"
      end

      if group.matter.code == "CM053" && group.name == "A" && group.course.name == "Matemática Diurno"
        group.vacancies = group.vacancies + 40
        group.course.name = group.course.name + ", Matemática Industrial"
      end
      if group.matter.code == "CM053" && group.name == "A" && group.course.name == "Matemática Industrial"
        i = "a"
      end

      if group.matter.code == "CM068" && group.name == "A" && group.course.name == "Matemática Diurno"
        group.vacancies = group.vacancies + 40
        group.course.name = group.course.name + ", Matemática Industrial"
      end
      if group.matter.code == "CM068" && group.name == "A" && group.course.name == "Matemática Industrial"
        i = "a"
      end

      if group.matter.code == "CM102" && group.name == "A" && group.course.name == "Matemática Diurno"
        group.vacancies = group.vacancies + 20
        group.course.name = group.course.name + ", Matemática Industrial"
      end
      if group.matter.code == "CM102" && group.name == "A" && group.course.name == "Matemática Industrial"
        i = "a"
      end

      if i!="a"
        rows.push [get_code(group), get_classes(group), get_matter(group), get_schedule(group),
          get_vacancies(group), get_classroom(group), get_course(group), get_teacher(group)]
      end


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

    table_data = get_rows
    table(table_data, header: true, cell_style: {size: 11}, column_widths: [60,45,160,130,50,50,120,150], position: 5) do
      row(0).style font_style: :bold, align: :center
    end

  end

  def table_header
    move_down 7

    text_box "Código", style: :bold, size: 12, :at => [10, cursor]
    text_box "Turma", style: :bold, size: 12, :at => [10, cursor]
    text_box "Código", style: :bold, size: 12, :at => [10, cursor]
    text_box "Horários", style: :bold, size: 12, :at => [380, cursor]
    text_box "Nº Alunos", style: :bold, size: 12, :at => [500, cursor]
    text_box "Sala", style: :bold, size: 12, :at => [550, cursor]
    text_box "Curso", style: :bold, size: 12, :at => [600, cursor]
    text_box "Professor", style: :bold, size: 12, :at => [670, cursor]

    move_down 15
    transparent (0.5) { stroke_horizontal_line 0, 770, :at=>  cursor}

  end

  def getSemester(ficha)
    return ficha.semester.to_s + "º de " + ficha.year.to_s
  end

end
