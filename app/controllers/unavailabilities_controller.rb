class UnavailabilitiesController < ApplicationController
  before_action :set_unavailability, only: [:destroy]

  def create

    @unavailability = Unavailability.new(unavailability_params)
    schedule = Schedule.new(schedule_params)
    schedule.parse_to_time

    #força o padrão...
    schedule.begin = schedule.begin.change(min: 30)
    schedule.duration = schedule.duration.change(min: 0)


    result = Schedule.where(day: schedule.day, begin: schedule.begin, duration: schedule.duration).first
    if result.blank?
      @unavailability.schedule = schedule
    else
      @unavailability.schedule = result
    end

    @availability = @unavailability.availability

    respond_to do |format|
      if @unavailability.save
        format.js
        format.html { redirect_to @unavailability, notice: 'Restrição foi cridada com sucesso.' }
      else
        format.js
        format.html { render :new }
      end
    end

  end

  #?
  def update
    respond_to do |format|
      if @unavailability.update(unavailability_params)
        format.html { redirect_to @unavailability, notice: 'Restrição foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @unavailability }
      else
        format.html { render :edit }
        format.json { render json: @unavailability.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @unavailability.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to user_availability_availabilities_path, notice: 'Restrição foi excluída com sucesso.' }
    end
  end

  private
    def set_unavailability
      @unavailability = Unavailability.find(params[:id])
    end

    def unavailability_params
      params.require(:unavailability).permit(:availability_id, schedule_attributes: [:begin, :duration, :day])
    end

    def schedule_params
      params.require(:schedule).permit(:begin, :duration, :day)
    end
end
