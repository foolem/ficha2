class ContactsController < ApplicationController
    before_action :bar_define

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])

    if @contact.valid?
      ContactMailer.contact_message(params[:contact]).deliver
      flash[:notice] = 'Mensagem enviado com sucesso'
      redirect_to help_contacts_path
      return
    end

    render :action => 'new'
  end

  def bar_define
    session[:page] = "help"
  end

end
