class Importation < Semester

  def self.find_matter(code, name)
    matters = Matter.where(code: code)
    if matters.length == 0
      matter = Matter.new(code: code, name: name, menu: "Ementa...", modality: "Presencial",
      nature: "Obrigatória", kind: "Presencial", prerequisite: "Nenhum", corequisite: "Nenhum")

      matter.save
    else
      matter = matters.first
    end
    matter
  end

  def self.find_course(code)
    courses = Course.where(code: code)
    if courses.length == 0
      course = Course.new(code: code, name: "CURSO NÃO ENCONTRADO")
      course.save
    else
      course = courses.first
    end
    course
  end

  def self.name_pattern(name)
    words = name.split.map do |piece|
      if @romans.include? piece.upcase
        piece.upcase
      elsif @conectives.include? piece.downcase
        piece.downcase
      else
        piece.capitalize
      end
    end
    words.join(" ")
  end

  def self.find_group(course ,matter, group_name, group_vacancies)
    groups = Group.where(course_id: course.id, matter_id: matter.id, name: group_name,
      vacancies: group_vacancies, semester_id: Semester.current_semester.id)
    if groups.length == 0
      group = Group.new(course_id: course.id, matter_id: matter.id, name: group_name,
        vacancies: group_vacancies, semester_id: Semester.current_semester.id)
      group.save
    else
      group = groups.first
    end
    group
  end

  def self.find_schedule(day, start, duration)
    schedules = Schedule.where(begin: start, duration: duration, day: day)
    if schedules.length == 0
      schedule = Schedule.new(begin: start, duration: duration, day: day)
      schedule.save
    else
      schedule = schedules.first
    end
    schedule
  end

  def self.add_schedule(group, schedule)
    if !group.schedules.include? schedule
      group.schedules.push schedule
    end
    group
  end

  def self.get_time(input)
    hour = input[0..1].to_i
    minute = input[3..4].to_i
    Time.new(2000, 1, 1, hour, minute, 0, 0)
  end

  def self.get_duration(s_begin, s_end)
    s_end - (s_begin.hour.hours + s_begin.min.minutes)
  end

  def self.import_groups(file)
    xlsx = Roo::Spreadsheet.open(file.path)
    matters_list = []
    groups_list = []
    new_matters = []

    sheet = xlsx.sheet(0)
    (sheet.last_row() -1).times do |i|
      linha = sheet.row(i+2)

      matter_code = linha[0].chomp.upcase
      matter_name = linha[1].chomp
      matter = self.find_matter(matter_code, matter_name)

      course_code = linha[8].chomp[0 .. -2].to_i
      course = find_course(course_code)
      group_name = linha[2].chomp
      group_vacancies = linha[3]
      group = self.find_group(course ,matter, group_name, group_vacancies)

      matters_item = { code: matter_code, name: matter_name, group: group_name }
      if !matters_list.include? matters_item
        matters_list.push matters_item
      end

      input_schedule = linha[4]
      if !input_schedule.blank?
        line_day = linha[4].first.to_i
        schedule_begin = self.get_time(linha[5])
        schedule_end = self.get_time(linha[6])
        schedule_duration = self.get_duration(schedule_begin, schedule_end)
        schedule = self.find_schedule(line_day -1, schedule_begin, schedule_duration)
        print "."
        group = self.add_schedule(group, schedule)
      end

      groups_item = {group_id: group.id, matter: group.matter.code, matter_name: group.matter.name, group_name: group.name, vacancies: group.vacancies, course: group.course.name, schedules: group.schedules }
      if !groups_list.include? groups_item
        groups_list.push groups_item
      end

      @groups = groups_list.group_by {|k,v| k[:matter]}

    end
    @to_unite = []
    @groups.each do |name,content|
      puts name
      content.each do |m|
        puts "#{m[:matter]}: #{m[:group_name]}"
        schedules = m[:schedules]
        schedules.each do |schedule|
          puts "#{schedule.begin} - #{schedule.duration} - #{schedule.day}"
          schedule = "#{schedule.begin} - #{schedule.duration} - #{schedule.day}"
          groups_item = {group_id: m[:group_id], matter: m[:matter], matter_name: m[:matter_name], group_name: m[:group_name], vacancies: m[:vacancies], course: m[:course], schedule: schedule }
          @to_unite.push(groups_item)
        end
      end
    end

    @schedules = @to_unite.group_by { |k, v| [k[:matter_name], k[:schedule]] }

    @schedules.each do |name, content|
      puts name
      puts "----------"
      content.each do |s|
        puts "#{s[:matter]} - #{s[:matter_name]} - #{s[:group_name]} - #{s[:schedule]}"
        puts "----------"
      end
    end
  end


  def self.course_existence(code, name)
    course = Course.where(code: code)
    if course.length == 0
      course = Course.new(code: code, name: name)
      course.save
      puts "#{course.id}\t#{code}\t#{name}"
    else
      puts "Curso já existente (#{name})"
    end
  end


  def self.import_courses(file)
    @romans = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII"]
    @conectives = ["e", "de", "para", "a", "à", "às", "em"]
    xlsx = Roo::Spreadsheet.open(file.path)

    puts "============= COURSES ============="
    sheet = xlsx.sheet(0)
    puts "ID\tCODE\tNAME\t"
    (sheet.last_row).times do |i|
      linha = sheet.row(i+1)

      code = linha[0]
      name = name_pattern(linha[1].chomp)
      self.course_existence(code, name)

    end
  end


end
