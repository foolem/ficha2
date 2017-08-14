namespace :utils do

  desc "Inset of teachers and matters"
  task init: :environment do

      def pass_generate
        password = ""
        character = ['1', '2', '3', 'a', 'b', 'c', 'd']
        6.times do |i|
          password << character[Random.rand(7)]
        end
        password
      end

      path = "lib/assets/inserts.xlsx"
      xlsx = Roo::Excelx.new(path, extension: :xlsx)

      puts "------------ Users ------------"
      (xlsx.sheet(1).last_row - 1).times do |i| #mudar pra sheet 3 para teste
        linha = xlsx.sheet(1).row(i+2)

        name = linha[0]
        email = linha[1]
        role = linha[2]

        if(linha[2].blank?)
            role = 0
        end
        password = pass_generate

        puts "|  #{name}  -  #{email} - #{role} - #{password} "
        user = User.create(name: name, email: email, password: password,  role: role)

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
        nature: "Obrigatória", kind: "Presencial", prerequisite: "Nenhum", corequisite: "Nenhum", bibliography: "q")

      end

      Semester.create(semester: 2, year: 2017)

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
        matter = Matter.where("code = '#{code}'")[0].id

        group = Group.create(matter_id: matter, name: team, semester_id: 1)
        Ficha.create(group_id: group.id, user_id: user)
      end

  end

end
