class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy, :remove]
  before_action :set_group, only: [:create, :remove]

  def index
    @schedules = Schedule.all
  end

  def show
  end

  def new
    @schedule = Schedule.new()
  end

  def edit
  end

  def remove
    @schedule.groups.delete(@group)
    respond_to do |format|
        format.js { flash[:alert] = "Horário removido com sucesso."}
    end
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.begin = @schedule.begin.to_time
    @schedule.duration = @schedule.duration.to_time

    result = Schedule.where(day: @schedule.day, begin: @schedule.begin, duration: @schedule.duration).first

    if !result.blank?

      if @group.schedules.include? result
        respond_to do |format|
            format.js { flash[:alert] = "Horário já existente."}
        end
      else
        @schedule = result
        @schedule.groups << @group
        @schedule.update
        flash[:notice] = "Horário adicionado com sucesso."
        respond_to do |format|
            format.js
        end
      end
    else
      @schedule.groups << @group
      respond_to do |format|
        if @schedule.save
          flash[:notice] = "Horário adicionado com sucesso."
          format.js
          format.html
        else
          flash[:notice] = "Erro ao adicionar horário."
          format.js
          format.html { render :new }
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to @schedule, notice: 'Horário foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to schedules_url, notice: 'Horário foi excluído com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:id_group])
    end

    def schedule_params
      params.require(:schedule).permit(:begin, :duration, :day)
    end
end
