# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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

  #id = Random.rand(matter.id)
  email = Faker::Internet.safe_email
  Teacher.create(name: name, email:email)

  puts ("Criando professor #{name}, #{email}, #{matter.name}")

end

matter = Matter.last
teacher = Teacher.last

10.times do |i|

  name = Faker::Name.name
  matter_id = Random.rand(matter.id)
  teacher_id = Random.rand(teacher.id)

  Ficha.create(matter_id: matter_id, teacher_id: teacher_id, general_objective: "Desenvolver habilidades em...",
  specific_objective: "Aprender x\nEntender y\nInterpretar z")
  puts ("Criando ficha: #{matter_id}, #{teacher_id}")

end
