class UniteMattersController < ApplicationController
  before_action :set_unite_matter, only: [:show, :edit, :update, :destroy]
  before_action :bar_define

  # GET /unite_matters
  # GET /unite_matters.json
  def index
    @unite_matters = UniteMatter.all
  end

  # GET /unite_matters/1
  # GET /unite_matters/1.json
  def show
  end

  # GET /unite_matters/new
  def new
    @unite_matter = UniteMatter.new
  end

  # GET /unite_matters/1/edit
  def edit
  end

  # POST /unite_matters
  # POST /unite_matters.json
  def create
    @unite_matter = UniteMatter.new(unite_matter_params)

    respond_to do |format|
      if @unite_matter.save
        format.html { redirect_to @unite_matter, notice: 'Unite matter was successfully created.' }
        format.json { render :show, status: :created, location: @unite_matter }
      else
        format.html { render :new }
        format.json { render json: @unite_matter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unite_matters/1
  # PATCH/PUT /unite_matters/1.json
  def update
    respond_to do |format|
      if @unite_matter.update(unite_matter_params)
        format.html { redirect_to @unite_matter, notice: 'Unite matter was successfully updated.' }
        format.json { render :show, status: :ok, location: @unite_matter }
      else
        format.html { render :edit }
        format.json { render json: @unite_matter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unite_matters/1
  # DELETE /unite_matters/1.json
  def destroy
    @unite_matter.destroy
    respond_to do |format|
      format.html { redirect_to unite_matters_url, notice: 'Unite matter was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unite_matter
      @unite_matter = UniteMatter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unite_matter_params
      params.require(:unite_matter).permit(:name)
    end

    def bar_define
      session[:page] = "unite_matters"
    end
end
