module WishesHelper

  def user_has_wishes?
    current_user.wishes.length < 5
  end

  def option_wished(option)
    option.users.include? current_user
  end

  def priority_list
    all = [1,2,3,4,5]
    wishes = current_user.wishes.select { |wish| wish.option.semester == current_semester }
    priorities = []
    wishes.each do |wish|
      priorities.push(wish.priority)
    end
    priorities.each {|pr| puts "Elemento: #{pr}"}
    all.each {|pr| puts "Elemento: #{pr}"}

    all - priorities
  end

end
