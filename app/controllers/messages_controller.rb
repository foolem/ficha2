class MattersController < ApplicationController



  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @matter.save
        format.html { redirect_to @matter, notice: 'Disciplina foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @matter }
      else
        format.html { render :new }
        format.json { render json: @matter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @matter.actived = !@matter.actived

    respond_to do |format|
      if(@matter.save)
        if(@matter.actived?)
          format.html { redirect_to matters_url, notice: 'Matéria ativada com sucesso.' }
        else
          format.html { redirect_to matters_url, notice: 'Matéria desativada com sucesso.' }
        end
        format.json { head :no_content }
      else
        format.html { redirect_to matters_url, alert: 'Erro ao atualizar matéria.' }
      end

    end
  end
  private

    def set_matter
      @matter = Matter.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:message, :ficha_id, :user_id)
    end

end
