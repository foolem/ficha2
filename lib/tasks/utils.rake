namespace :utils do

  desc "Inset of teachers and matters"
  task init: :environment do

      def pass_generate
        password = ""
        character = ['1', '2', '3', 'a', 'b', 'c']
        6.times do |i|
          password << character[Random.rand(6)]
        end
        password
      end

      def make_begin(date)
        hour = date[0..1].to_i
        min = date[3..4].to_i
        Time.new(2000, 1, 1, hour, min, 0, 0)
      end

      def make_duration(date)
        start = date[0..4]
        ends = date[8..12]
        start_hour = start[0..1].to_i
        start_min = start[3..4].to_i

        ends_hour = ends[0..1].to_i
        ends_min = ends[3..4].to_i

        hour =  ends_hour - start_hour
        min = ends_min - start_min

        if min >= 60
          min -= 60
          hour += 1
        end
        Time.new(2000, 1, 1, hour, min, 0, 0)
      end

      def schedule_associate(day, date, group)
        if !day.blank?
          day = day.to_i - 1

          start = make_begin(date[0..4])
          duration = make_duration(date)

          schedule = find_schedule(day, start, duration)
          schedule.groups << group
          schedule.save
          puts "|  #{day}  -  #{date} |"

        end
      end

      def find_schedule(day, start, duration)
        schedule = Schedule.where(begin: start, duration: duration, day: day)[0]
        if schedule.blank?
          schedule = Schedule.create(begin: start, duration: duration, day: day)
        end
        schedule
      end

      path = "lib/assets/inserts.xlsx"
      xlsx = Roo::Excelx.new(path, extension: :xlsx)

      puts "\n============= USERS ============="
      roles = ["teacher", "appraiser", "admin", "secretary", "counselor"]

      (xlsx.sheet(1).last_row - 1).times do |i| 
        linha = xlsx.sheet(1).row(i+2)

        name = linha[0]
        email = linha[1]
        role = linha[2]

        if(linha[2].blank?)
            role = 0
        end

        password = pass_generate

        puts "|  #{name}  -  #{email} - #{role} - #{password} "
        user = User.create(name: name, email: email,  role: role, password: password)

        if (role != 3 and role != 0)
          user.add_role "teacher"
          user.add_role roles[role]
        elsif (role == 0)
          user.add_role "teacher"
        else
          user.add_role "secretary"
        end

        user.save
        #if user.save
          #  UserMailer.send_password(user).deliver

        #end

      end

      puts "\n------------ Matters ------------"
      path = "lib/assets/inserts.xlsx"
      xlsx = Roo::Excelx.new(path, extension: :xlsx)

      (xlsx.sheet(0).last_row - 1).times do |i|
        linha = xlsx.sheet(0).row(i+2)

        puts "|  #{linha[0]}  -  #{linha[1]} "
        code = linha[0].upcase
        name = linha[1]

        Matter.create(code: code, name: name, menu: "Exemplo", modality: "Presencial",
        nature: "Obrigatória", kind: "Presencial", prerequisite: "Nenhum", corequisite: "Nenhum")

      end

      Semester.create(semester: 1, year: 2018)

      puts "\n------------ Fichas ------------"
      path = "lib/assets/inserts.xlsx"
      xlsx = Roo::Excelx.new(path, extension: :xlsx)

      (xlsx.sheet(2).last_row).times do |i|
        linha = xlsx.sheet(2).row(i+1)

        puts "|  #{linha[0]}  -  #{linha[1]} -  #{linha[2]} "

        code = linha[0].upcase
        team = linha[1].upcase
        name = linha[2]

        user = User.where(name:  name)[0].id
        matter = Matter.where(code: code)[0].id

        group = Group.create(matter_id: matter, name: team, semester_id: 1, course_id: Random.rand(39) + 1)
        #Ficha.create(group_id: group.id, user_id: user)

        schedule_associate(linha[3], linha[4], group)
        schedule_associate(linha[5], linha[6], group)
        schedule_associate(linha[7], linha[8], group)


      end

      unite = UniteMatter.create(name: "Álgebra Linear")
      unite.matters << Matter.where(code: "CM005").first
      unite.matters << Matter.where(code: "CMA212").first

  end

  desc "Inset of teachers and matters"
  task init_2018: :environment do

    def find_matter(code, name)
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

    def name_pattern(name)
      words = name.split.map do |peace|
        if @romans.include? peace.upcase
          peace.upcase
        elsif @conectives.include? peace.downcase
          peace.downcase
        else
          peace.capitalize
        end
      end
      words.join(" ")
    end

    @romans = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII"]
    @conectives = ["e", "de", "para", "a", "à", "às", "em"]

    path = "lib/assets/cursos.xlsx"
    xlsx = Roo::Excelx.new(path, extension: :xlsx)

    puts "============= COURSES ============="
    sheet = xlsx.sheet(0)
    puts "ID\tCODE\tNAME\t"
    (sheet.last_row).times do |i|
      linha = sheet.row(i+1)

      code = linha[0]
      name = name_pattern(linha[1].chomp)
      course = Course.new(code: code, name: name)
      course.save

      puts "#{course.id}\t#{code}\t#{name}"
    end

    path = "lib/assets/2018.xlsx"
    xlsx = Roo::Excelx.new(path, extension: :xlsx)

    puts "\n============= MATTERS ============="
    sheet = xlsx.sheet(0)

    puts "ID\tCODE\tMATTER\t"
    (sheet.last_row() -1).times do |i|
      linha = sheet.row(i+2)

      matter_code = linha[0].chomp.upcase
      matter_name = name_pattern(linha[1].chomp)

      matter = find_matter(matter_code, matter_name)
      puts "#{matter.id}\t#{matter_code}\t#{matter_name}"
    end
  end
end
