# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# rake db:drop db:create db:migrate db:seed

30.times do |i|

  name = Faker::Food.ingredient
  code = Faker::Code.asin
  kind = [:Semestral, :Anual, :Modular].sample
  modality = [:Presencial, :EaD].sample
  nature = [:Obrigatoria, :Optativa].sample

  if name[0] >= 'a'
    name[0] = name[0].upcase
  end

  Matter.create(name: name, code: code, kind: kind,
  prerequisite: "Nenhum", corequisite: "Nenhum",
  modality: modality , nature: nature,
  total_weekly_workload: 0, total_modular_workload: 0, total_annual_workload: 0, weekly_workload: 0,
  pd:0, lc:0, cp:0, es:0, or:0)

  puts ("Criando matéria #{name}")

end

matter = Matter.last

30.times do |i|

  name = Faker::Name.name
  email = Faker::Internet.safe_email
  User.create(name: name, email:email, password: "123123")

  puts ("Criando professor #{name}, #{email}")

end

matter = Matter.last
teacher = User.where(role: 0).last

15.times do |i|

  name = Faker::Name.name
  matter_id = Random.rand(matter.id - 1)
  teacher_id = Random.rand(teacher.id - 1)

  Ficha.create(matter_id: matter_id + 1, user_id: teacher_id + 1, general_objective: "Desenvolver habilidades em...",
  specific_objective: "Aprender x\nEntender y\nInterpretar z")
  puts ("Criando ficha: #{matter_id + 1}, #{teacher_id + 1}")

end

20.times do |i|

  name = Faker::Name.name
  matter_id = Random.rand(matter.id - 1)
  teacher_id = Random.rand(teacher.id - 1)

  Ficha.create(matter_id: matter_id + 1, user_id: teacher_id + 1, general_objective: "Desenvolver habilidades em...",
  specific_objective: "Aprender x\nEntender y\nInterpretar z", status: "Reprovado", appraisal: "Bibliografia fora das normas")
  puts ("Criando ficha: #{matter_id + 1}, #{teacher_id + 1}, status: Reprovado")

end


30.times do |i|

  name = Faker::Name.name
  matter_id = Random.rand(matter.id - 1)
  teacher_id = Random.rand(teacher.id - 1)

  Ficha.create(matter_id: matter_id + 1, user_id: teacher_id + 1, general_objective: "Desenvolver habilidades em...",
  specific_objective: "Aprender x\nEntender y\nInterpretar z", status: "Aprovado")
  puts ("Criando ficha: #{matter_id + 1}, #{teacher_id + 1}, status: Aprovado")

end


User.create(name: "Professor", email: "prof@prof", password: "123123",  role: 0)
User.create(name: "Avaliador", email: "av@av", password: "123123",  role: 1)
User.create(name: "Admin", email: "adm@adm", password: "123123",  role: 2)

Ficha.create(matter_id: 1, user_id: 31, general_objective: "Desenvolver habilidades em...",
specific_objective: "Aprender x\nEntender y\nInterpretar z", status: "Aprovado")

Ficha.create(matter_id: 2, user_id: 31, general_objective: "Desenvolver habilidades em...",
specific_objective: "Aprender x\nEntender y\nInterpretar z", status: "Reprovado", appraisal: "Melhore x e y")

Ficha.create(matter_id: 3, user_id: 31, general_objective: "Desenvolver habilidades em...",
specific_objective: "Aprender x\nEntender y\nInterpretar z")
