namespace :utils do

  desc "Inset of teachers and matters"
  task init: :environment do

      path = "lib/assets/inserts.xlsx"
      xlsx = Roo::Excelx.new(path, extension: :xlsx)

      puts "------------ Users ------------"
      (xlsx.sheet(1).last_row - 1).times do |i|
        linha = xlsx.sheet(1).row(i+2)

        puts "|  #{linha[0]}  -  #{linha[1]} - #{linha[2]} "
        name = linha[0]
        email = linha[1]
        role = linha[2]

        if(linha[2].blank?)
            role = 0
        end

        User.create(name: name, email: email, password: "123123",  role: role)
      end

      puts "\n------------ Matters ------------"
      path = "lib/assets/inserts.xlsx"
      xlsx = Roo::Excelx.new(path, extension: :xlsx)

      (xlsx.sheet(0).last_row - 1).times do |i|
        linha = xlsx.sheet(0).row(i+2)

        puts "|  #{linha[0]}  -  #{linha[1]} "
        code = linha[0]
        name = linha[1]

        Matter.create(code: code, name: name, menu: "Exemplo", modality: "Presencial",
        nature: "Obrigatória", kind: "Presencial", prerequisite: "Nenhum", corequisite: "Nenhum")

      end

  end


end
