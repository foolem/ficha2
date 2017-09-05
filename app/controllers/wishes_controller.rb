class WishesController < ApplicationController
  before_action :set_wish, only: [:show, :edit, :update, :destroy]
  before_action :set_option, only: [:create, :remove]

  # GET /wishes
  # GET /wishes.json
  def index
    @wishes = Wish.all
  end

  # GET /wishes/1
  # GET /wishes/1.json
  def show
  end

  # GET /wishes/new
  def new
    @wish = Wish.new
  end

  # GET /wishes/1/edit
  def edit
  end

  # POST /wishes
  # POST /wishes.json
  def create
    @wish = Wish.new(wish_params)
    @wish.option = @option
    @wish.user = current_user

    respond_to do |format|
      if @wish.save
        format.js
        format.html { redirect_to option_path(@option), notice: 'Wish was successfully updated.' }
      else
        format.js
        format.html
      end
    end
  end

  # PATCH/PUT /wishes/1
  # PATCH/PUT /wishes/1.json
  def update
    respond_to do |format|
      if @wish.update(wish_params)
        format.html { redirect_to @wish, notice: 'Wish was successfully updated.' }
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
        format.html { redirect_to options_path, notice: 'Wish was successfully destroyed.' }
        format.js { flash[:alert] = "Desejo removido com sucesso."}
    end
  end
  # DELETE /wishes/1
  # DELETE /wishes/1.json
  def destroy
    @wish.destroy
    respond_to do |format|
      format.html { redirect_to wishes_url, notice: 'Wish was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wish
      @wish = Wish.find(params[:id])
    end

    def set_option
      @option = Option.find(params[:option_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wish_params
      params.require(:wish).permit(:option_id, :user_id, :group_id, :priority)
    end
end
