class WishesController < ApplicationController
  before_action :set_wish, only: [:show, :edit, :update, :destroy]
  before_action :set_option, only: [:create, :remove]

  def index
    @wishes = Wish.all
  end

  def new
    @wish = Wish.new
  end
  def edit
  end


  def create
    @wish = Wish.new(wish_params)
    @wish.option = @option
    @wish.semester_id = Semester.current_semester.id
    @wish.user = current_user

    respond_to do |format|
      if @wish.save

        if !user_has_wishes?
          format.js
          format.html { redirect_to user_availability_availabilities_path, notice: 'Opção escolhida com sucesso.' }
        end

        format.js
        format.html { redirect_to options_path, notice: 'Opção escolhida com sucesso.' }
      else
        format.js
        format.html
      end
    end
  end

  def update
    respond_to do |format|
      if @wish.update(wish_params)
        format.html { redirect_to @wish, notice: 'Desejo foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @wish }
      else
        format.html { render :edit }
        format.json { render json: @wish.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove
    @wish = @option.wishes.select {|wish| wish.user == current_user}.first
    puts "\n\n #{@wish.user.name}, #{@wish.option.id} "
    if @option.wishes.include? @wish
      puts "Inclui mesmo"
      @option.wishes.delete(@wish)
      @wish.destroy
    end

    respond_to do |format|
        format.html { redirect_to options_path, notice: 'Opção foi excluído com sucesso.' }
        format.js { flash[:alert] = "Desejo removido com sucesso."}
    end
  end

  def destroy
    @wish.destroy
    respond_to do |format|
      format.html { redirect_to wishes_url, notice: 'Opção foi excluído com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

    def user_has_wishes?
      current_user.wishes.length < 5
    end

    def set_wish
      @wish = Wish.find(params[:id])
    end

    def set_option
      @option = Option.find(params[:option_id])
    end

    def wish_params
      params.require(:wish).permit(:option_id, :user_id, :group_id, :priority)
    end
end
