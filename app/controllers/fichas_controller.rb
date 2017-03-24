class FichasController < ApplicationController
  before_action :set_ficha, only: [:show, :edit, :update, :destroy]

  # GET /fichas
  # GET /fichas.json
  def index
    @fichas = Ficha.all
  end

  # GET /fichas/1
  # GET /fichas/1.json
  def show
  end

  # GET /fichas/new
  def new
    @ficha = Ficha.new
  end

  # GET /fichas/1/edit
  def edit
  end

  # POST /fichas
  # POST /fichas.json
  def create
    @ficha = Ficha.new(ficha_params)

    respond_to do |format|
      if @ficha.save
        format.html { redirect_to @ficha, notice: 'Ficha was successfully created.' }
        format.json { render :show, status: :created, location: @ficha }
      else
        format.html { render :new }
        format.json { render json: @ficha.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fichas/1
  # PATCH/PUT /fichas/1.json
  def update
    respond_to do |format|
      if @ficha.update(ficha_params)
        format.html { redirect_to @ficha, notice: 'Ficha was successfully updated.' }
        format.json { render :show, status: :ok, location: @ficha }
      else
        format.html { render :edit }
        format.json { render json: @ficha.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fichas/1
  # DELETE /fichas/1.json
  def destroy
    @ficha.destroy
    respond_to do |format|
      format.html { redirect_to fichas_url, notice: 'Ficha was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ficha
      @ficha = Ficha.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ficha_params
      params.require(:ficha).permit(:program, :general_objective, :specific_objective, :didactic_procedures, :evaluation, :basic_bibliography, :bicliography, :teacher_id, :matter_id)
    end
end
