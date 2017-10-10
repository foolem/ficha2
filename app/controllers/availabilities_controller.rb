class AvailabilitiesController < ApplicationController
  before_action :bar_define
  before_action :set_availability, only: [:show, :edit, :update, :destroy]


  def index
    @availabilities = Availability.all
  end

  def show
  end

  def new
    @availability = Availability.new
  end

  def edit
  end

  def create
    @availability = Availability.new(availability_params)

    respond_to do |format|
      if @availability.save
        format.html { redirect_to @availability, notice: 'Availability was successfully created.' }
        format.json { render :show, status: :created, location: @availability }
      else
        format.html { render :new }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @availability.update(availability_params)
        format.html { redirect_to @availability, notice: 'Availability was successfully updated.' }
        format.json { render :show, status: :ok, location: @availability }
      else
        format.html { render :edit }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @availability.destroy
    respond_to do |format|
      format.html { redirect_to availabilities_url, notice: 'Availability was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def user_availability
    @availability = Availability.where(user_id: current_user.id, semester_id: Semester.current_semester.id).first
    if @availability.blank?
      @availability = Availability.new(user_id: current_user.id, semester_id: Semester.current_semester.id)
      @availability.save
    end
  end

  private

    def bar_define
      session[:page] = "options"
    end

    def set_availability
      @availability = Availability.find(params[:id])
    end

    def availability_params
      params.require(:availability).permit(:semester_id, :user_id)
    end
end
