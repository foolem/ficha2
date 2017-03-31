class MattersController < ApplicationController
  before_action :set_matter, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate_user!

  # GET /matters
  # GET /matters.json
  def index
    @q = Matter.ransack(params[:q])
    @matters = @q.result
    #@matters = @matters.paginate(:page => params[:page], :per_page => 15)
    order
  end

  # GET /matters/1
  # GET /matters/1.json
  def show
  end

  # GET /matters/new
  def new
    @matter = Matter.new
    @matter.prerequisite = "Nenhum"
    @matter.corequisite = "Nenhum"
    @matter.total_annual_workload = 0
    @matter.total_weekly_workload = 0
    @matter.total_modular_workload = 0
    @matter.weekly_workload = 0
    @matter.pd = 0
    @matter.lc = 0
    @matter.cp = 0
    @matter.es = 0
    @matter.or = 0
  end

  # GET /matters/1/edit
  def edit
  end

  # POST /matters
  # POST /matters.json
  def create
    @matter = Matter.new(matter_params)

    respond_to do |format|
      if @matter.save
        format.html { redirect_to @matter, notice: 'Matter was successfully created.' }
        format.json { render :show, status: :created, location: @matter }
      else
        format.html { render :new }
        format.json { render json: @matter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matters/1
  # PATCH/PUT /matters/1.json
  def update
    respond_to do |format|
      if @matter.update(matter_params)
        format.html { redirect_to @matter, notice: 'Matter was successfully updated.' }
        format.json { render :show, status: :ok, location: @matter }
      else
        format.html { render :edit }
        format.json { render json: @matter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matters/1
  # DELETE /matters/1.json
  def destroy
    @matter.destroy
    respond_to do |format|
      format.html { redirect_to matters_url, notice: 'Matter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matter
      @matter = Matter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matter_params
      params.require(:matter).permit(:name, :code, :kind, :corequisite, :prerequisite, :modality, :menu, :nature,
      :total_annual_workload, :total_weekly_workload, :total_modular_workload, :weekly_workload,
      :pd, :lc, :cp, :es, :or)
    end

    def order
      @matters = @matters.sort_by {|matter| matter.name}
    end
end
