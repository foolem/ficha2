class FichasController < ApplicationController
  before_action :set_ficha, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :create]

  # GET /fichas
  # GET /fichas.json
  def index
    @fichas = Ficha.order(status: :desc)

    if(!user_signed_in?)

      @fichas = Ficha.order(created_at: :desc).where(status: "Aprovado")
    end
  end

  # GET /fichas/1
  # GET /fichas/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        pdf.text "Hello word"

        send_data pdf.render,
          filename: "Ficha2 #{@ficha.matter.name} #{@ficha.teacher.name}",
          type: "application/pdf",
          disposition: "inline"
      end
    end
  end

  # https://www.youtube.com/watch?v=e-A3zBeWDdE

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

        @ficha.teacher = Teacher.first

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
      params.require(:ficha).permit(:program, :general_objective, :specific_objective,
                                    :didactic_procedures, :evaluation, :basic_bibliography,
                                    :bicliography, :teacher_id, :matter_id, :appraisal, :status)
    end

    def authorize_user
      authorize Ficha
    end
end
