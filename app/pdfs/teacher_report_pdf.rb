class TeacherReportPdf < Prawn::Document

  include OptionsHelper
  include UsersHelper

  def initialize(semester)
    super(top_margin: 20)
    if semester.blank?
      @semester = Semester.current_semester
    else
      @semester = Semester.find(semester)
    end
    @margem = 50
    @number = 0
    record_generate
  end

  def get_options(user)
    result = [["Opção", "Disciplina", "Horário"]]
    wishes_ordered_report(user, @semester.id).each do |wish|
      opt = wish.option
      line = [wish.priority, matter_group(opt.matters.first), schedules_report(opt)]
      result.push line
    end
    result
  end

  def default_array
    column = {}
    t = Time.parse("2000/01/01 7:30")
    while t.hour != 22
      column["#{t.hour}:#{t.min}"] = false
      t += 1.hours
    end
    column
  end

  def column_day(user, day)
    schedules = Schedule.find_by_users_and_day(user, day)

    column = default_array
    schedules.each do |sch|
      start = sch.begin
      finish = sch.begin + sch.duration.hour.hours
      new_start = start

      while new_start != finish
        column["#{new_start.hour}:#{new_start.min}"] = true;
        new_start += 1.hours
      end
    end

    column
  end

  def header
    ["Horário",  "Segunda",  "Terça",  "Quarta",  "Quinta",  "Sexta"]
  end

  def get_columns(user)
    columns = []
    [1,2,3,4,5].each do |day|
      columns.push(column_day(user, day))
    end
    columns
  end

  def get_rows
    user = @user
    all_rows = []
    all_rows.push(header)
    t = Time.parse("2000/01/01 7:30")

    columns = get_columns(user)

    while t.hour != 22
      current_row = []
      current_row.push("#{t.strftime("%H:%M")} - #{(t + 1.hours).strftime("%H:%M")}")

      [1,2,3,4,5].each do |day|
        if columns[day - 1]["#{t.hour}:#{t.min}"]
          current_row.push("x")
        else
          current_row.push("")
        end
      end
      all_rows.push(current_row)
      t += 1.hours
     end
     all_rows
  end

  def header_generate
    move_down 5
    text  @user.name.upcase, size: 12, style: :bold, align: :center

    text  @user.email.downcase, size: 11, align: :center
    text_box "Pesquisador: ", size: 11, :at => [420,cursor+10], style: :bold
    text_box @availability.researcher ? "Sim" : "Não", size: 11, :at => [495,cursor+10]

    if !@user.phone.blank?
      text_box "Telefone: ", size: 11, :at => [20,cursor+10], style: :bold
      text_box @user.phone, size: 11, :at => [75,cursor+10]
    end
    move_down 5

    transparent (0.5) { stroke_horizontal_rule }
    transparent (0.5) {stroke_vertical_line cursor,17,:at=> 0}
    transparent (0.5) {stroke_vertical_line cursor,17,:at=> 540}
    transparent (0.5) { stroke_horizontal_line 0, 540, :at=> 17}

    @number+=1
    text_box  @number.to_s, size: 11, :at => [530,11]
  end

  def record_generate
    @users = User.joins(:availabilities).where("availabilities.semester_id = #{@semester.id}")
    @users.each do |user|
      if user.id == 1 or user.id == 2 or user.id == 3 or user.id == 4 or user.id == 7 or user.id == 60
        next
      end
      @user = user
      @availability = Availability.find_by_semester(@user, @semester.id)

      header_generate

      move_down 5
      text_box "Indisponibilidades", size: 12, style: :bold, :at => [0,cursor], align: :center
      move_down 15
      table get_rows, cell_style: {height: 19, size: 10, align: :center}, column_widths: [100,80,80, 80,80,80,80],position: 20
      move_down 5

      simple_title_generate "Justifcativa: ", 20, 5
      bounding_box([95, cursor], :width => 425) do
        text get_value(@availability.comments)
      end

      move_down 5
      transparent (0.5) { stroke_horizontal_rule }

      simple_title_generate "Preferências: ", 20, 5
      bounding_box([95, cursor], :width => 500) do
        font_size(12) { text "1º: #{get_preference(@availability.preference_first)}" }
        font_size(12) { text "2º: #{get_preference(@availability.preference_second)}" }
        font_size(12) { text "3º: #{get_preference(@availability.preference_third)}" }
      end

      move_down 5
      transparent (0.5) { stroke_horizontal_rule }

      #outras_escolhas

      move_down 5
      text_box "Escolhas", size: 12, style: :bold, :at => [0,cursor], align: :center
      move_down 15
      table get_options(@user),
        column_widths: [50, 200, 250], cell_style: {padding: 5, size: 10, align: :center},position: 20

      move_down 10
      transparent (0.5) { stroke_horizontal_rule }

      simple_title_generate "Comentários: ", 20, 5
      bounding_box([95, cursor], :width => 425) do
        text get_value(@availability.general_comments), size: 12
      end

      start_new_page
    end

    outstanding
  end

  def outstanding
    move_down 5
    text  "PENDÊNCIAS", size: 12, style: :bold, align: :center
    move_down 5

    transparent (0.5) { stroke_horizontal_rule }
    transparent (0.5) {stroke_vertical_line cursor,17,:at=> 0}
    transparent (0.5) {stroke_vertical_line cursor,17,:at=> 540}


    @number+=1
    text_box  @number.to_s, size: 11, :at => [530,11]

    move_down 15
    query = User.where("id not in (?) and actived = true and id != 1 and id != 2 and id != 3 and id != 4 and id != 7", @users.collect {|usr| usr.id}).map {|usr| [usr.name, usr.email] }
    table ([["Nome", "Email"]] + query),
    cell_style: {height: 18, size: 9}, column_widths: [250,250],position: 20
  end

  def simple_title_generate(title, x, move)
    move_down move
    text_box title, size: 11, style: :bold, :at => [x,cursor]
  end

  def getSemester(ficha)
    return ficha.semester.to_s + "º de " + ficha.year.to_s
  end

  def get_preference(input)
    if input.blank?
      return
    end

    ["Concentrar minhas aulas pela manhã",
    "Concentrar minhas aulas à tarde",
    "Concentrar minhas aulas à noite",
    "Não dar aulas às 7:30",
    "Não dar aulas à noite",
    "Concentrar todas minhas aulas em 2 ou 3 dias da semana",
    "Ficar apenas com disciplinas iguais","Dar duas aulas em sequência",
    "Não dar duas aulas em sequência"][input]
   end

   def get_value(text)
     if text.blank?
       return "Sem comentários registrados"
     end
     text
   end

  #http://prawnpdf.org/docs/0.11.1/index.html
  #http://prawnpdf.org/manual.pdf
  #https://github.com/prawnpdf/prawn-table
end
