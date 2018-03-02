class MatterReportPdf < Prawn::Document

  include OptionsHelper
  include MattersHelper
  include SchedulesHelper

  def initialize(semester)
    super(top_margin: 20, :page_size => "A4", :page_layout => :landscape)

    @user = User.find 58
    @availability = @user.availabilities.first
    if semester.blank?
      @semester_id = Semester.current_semester.id
    else
      @semester_id = Semester.find(semester).id
    end
    @margem = 50
    @number = 0
    record_generate
  end

  def header_generate(matter)
    move_down 5
    text  matter_group(matter), size: 12, style: :bold, align: :center
    move_down 5

    transparent (0.5) { stroke_horizontal_rule }
    move_down 15

    #transparent (0.5) {stroke_vertical_line cursor,17,:at=> 0}
    #transparent (0.5) {stroke_vertical_line cursor,17,:at=> 270}
    #transparent (0.5) { stroke_horizontal_line 0, 540, :at=> 17}

    #@number+=1
    #text_box  @number.to_s, size: 11, :at => [530,11]
  end

  def get_rows
    rows = []
    rows.push ["Opções", "Horários", "Docentes"]

    @options.each_with_index do |option, index|
      rows.push [get_groups(option), schedules_report(option), get_teachers(option)]
    end
    rows
  end

  def get_groups(option)
    groups = ""
    option.groups.each do |group|
      if group.active == nil || group.active == true
        groups << group.code_name_and_course
        groups << "\n"
      end
    end
    groups
  end

  def get_teachers(option)
    wishes = ""
    option.wishes.sort_by{ |w| w.priority }.each do |wish|
      wishes << "(#{wish.priority}) #{wish.user.name}\n"
    end
    wishes
  end

  def record_generate
    @unites = []
    matters_order.each do |matter|
      matter_options(matter)
      if !@options.blank?
        header_generate(matter)

        table_data = get_rows
        table(table_data, header: true, cell_style: {size: 11}, column_widths: [240,230,290], position: 5) do
          row(0).style font_style: :bold, align: :center # header style
        end

        move_down 15
      end
    end

  end

  def simple_title_generate(title, x, move)
    move_down move
    text_box title, size: 11, style: :bold, :at => [x,cursor]
  end

  def getSemester(ficha)
    return ficha.semester.to_s + "º de " + ficha.year.to_s
  end

end
