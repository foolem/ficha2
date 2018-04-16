class UserMailer < ActionMailer::Base
  default :from => 'ficha2.mat@gmail.com'

  def send_password(user)
    @user = user
    mail(:to => @user.email, :subject => 'Encargos Didáticos')
    #mail(:to => 'ficha2.mat@gmail.com', :subject => 'Mensagem de Contato')
  end

  def notify_record(user, group)
    @user = user
    @group = group
    mail(:to => @user.email, :subject => 'Preenchimento da ficha2')
  end

  def message_notification(message)
    @message = message
    mail(:to => @message.ficha.user.email, :subject => 'Nova mensagem sobre a sua ficha')
  end

end
