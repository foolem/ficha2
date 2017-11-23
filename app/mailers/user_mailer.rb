class UserMailer < ActionMailer::Base
  default :from => 'ficha2.mat@gmail.com'

  def send_password(user)
    @user = user
    mail(:to => @user.email, :subject => 'Encargos didáticos')
    #mail(:to => 'ficha2.mat@gmail.com', :subject => 'Mensagem de Contato')
  end

end
