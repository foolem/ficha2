class MessagesController < ApplicationController

  before_action :set_ficha

  def new
    @message = Message.new
  end

  def create

    @message = Message.new(message_params)
    @message.ficha = @ficha
    @message.user = current_user

    respond_to do |format|
      if !@message.message.blank? and @message.save
        format.js
      else
        format.js
      end
    end

    new
    set_ficha
  end

  def destroy
    @message.actived = !@message.actived

    respond_to do |format|
      if(@message.save)
        if(@message.actived?)
          format.html { redirect_to messages_url, notice: 'Matéria ativada com sucesso.' }
        else
          format.html { redirect_to messages_url, notice: 'Matéria desativada com sucesso.' }
        end
        format.json { head :no_content }
      else
        format.html { redirect_to messages_url, alert: 'Erro ao atualizar matéria.' }
      end

    end
  end

  private

    def set_message
      @message = Message.find(params[:id])
    end

    def set_ficha
      @ficha = Ficha.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:message, :ficha_id, :user_id)
    end

end
