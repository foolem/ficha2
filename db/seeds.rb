# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

20.times do |i|

  name = Faker::Food.ingredient
  code = Faker::Code.asin
  kind = [:Semestral, :Anual, :Modular].sample
  modality = [:Presencial, :EaD].sample
  menu = [:Obrigatoria, :Optativa].sample

  if name[0] >= 'a'
    name[0] = name[0].upcase
  end

  Matter.create(name: name, code: code, kind: kind,
  prerequisite: "Nenhum", corequisite: "Nenhum",
  modality: modality , menu: menu)

  puts ("Criando matéria #{name}")

end

matter = Matter.last
40.times do |i|

  name = Faker::Name.name
  id = Random.rand(matter.id)
  email = Faker::Internet.safe_email
  Teacher.create(name: name, email:email, matter_id: id )

  puts ("Criando professor #{name}, #{email}, #{matter.name}")

end

matter = Matter.last
teacher = Teacher.last

40.times do |i|

  name = Faker::Name.name
  matter_id = Random.rand(matter.id)
  teacher_id = Random.rand(teacher.id)

  Ficha.create(matter_id: matter_id, teacher_id: teacher_id, general_objective: "Desenvolver habilidades em...",
  specific_objective: "Aprender x\nEntender y\nInterpretar z")
  puts ("Criando ficha: #{matter_id}, #{teacher_id}")

end
