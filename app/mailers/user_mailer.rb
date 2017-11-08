class UserMailer < ActionMailer::Base
  default :from => 'ficha2.mat@gmail.com'

  def send_password(user)
    @user = user
    @time = Time.now.strftime("%d/%m/%Y %H:%M")
    mail(:to => @user.email, :subject => 'Troca de senha')
    #mail(:to => 'ficha2.mat@gmail.com', :subject => 'Mensagem de Contato')
  end

end
