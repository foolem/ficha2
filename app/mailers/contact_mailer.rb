class ContactMailer < ActionMailer::Base
  default :from => 'email_remetente@gmail.com'

  def contact_message(contact)
    @contact = Contact.new(contact)
    @time = Time.now.strftime("%d/%m/%Y %H:%M")
    mail(:to => 'ficha2.mat@gmail.com', :subject => 'Mensagem de Contato')
  end
end
