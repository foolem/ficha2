class MatterReportPdf < Prawn::Document

  include OptionsHelper
  include MattersHelper
  include SchedulesHelper

  def initialize()
    super(top_margin: 20, :page_size => "A4", :page_layout => :landscape)

    @user = User.find 58
    @availability = @user.availabilities.first

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
    rows.push ["Opções", "Horários", "Turmas", "Docentes"]

    @options.each_with_index do |option, index|
      rows.push [option.id, schedules_report(option), "Turmas...", "Wishes"]
      #option.groups.distinct.each do |group|
    #    puts "#{group.name} - #{group.matter.code} - #{group.course.name}"
  #    end

        #Interessados
      #option.wishes.each do |wish|
      #  <h6 class="text-center m-0" style="line-height:0px;"= wish.user.name, prioridade:= wish.priority</h6><br>
    # end
    end
    rows
  end

  def record_generate

    @unites = []
    matters_order.each do |matter|
      matter_options(matter)
      if !@options.blank?
        header_generate(matter)

        table get_rows, cell_style: {size: 11, align: :center}, column_widths: [200,190,190,180],position: 5

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
