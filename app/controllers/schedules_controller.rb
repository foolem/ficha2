class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]
  before_action :set_group, only: [:create]

  # GET /schedules
  # GET /schedules.json
  def index
    @schedules = Schedule.all
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
  end

  # GET /schedules/new
  def new
    @schedule = Schedule.new()
  end

  # GET /schedules/1/edit
  def edit
  end

  def remove
    set_group_id
    set_schedule
    @schedule.groups.delete(@group)
    respond_to do |format|
        format.js { flash[:alert] = "Horário removido com sucesso."}
    end
  end
  # POST /schedules
  # POST /schedules.json
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

  # PATCH/PUT /schedules/1
  # PATCH/PUT /schedules/1.json
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

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to schedules_url, notice: 'Horário foi excluído com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:id])
    end

    def set_group_id
      @group = Group.find(params[:id_group])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit(:begin, :duration, :day, :group_id)
    end
end
