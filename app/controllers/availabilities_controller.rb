class AvailabilitiesController < ApplicationController
  before_action :bar_define
  before_action :set_availability, only: [:show, :edit, :update, :destroy, :add_unavailability, :open_unavailability, :select_preference]


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
        format.js
        format.html { redirect_to availabilities_path, notice: 'Availability was successfully updated.' }
      else
        format.js
        format.html { render :edit }
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
    @availability.preference_first = 1
  end

  def open_unavailability
    @unavailability = Unavailability.new()
    respond_to do |format|
      format.js
    end
  end

  def add_unavailability
    respond_to do |format|
      format.js
      format.html { redirect_to root, notice: 'Restrição adicionada com sucesso.' }
    end
  end

  def select_preference
    preferences = {"1" => "preference_first_div", "2" =>"preference_second_div", "3" => "preference_third_div"}
    preference = params[:preference]

    @preference = preferences[preference]
    puts "Preferencia_id: #{@preference} "
    respond_to do |format|
      format.js
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
