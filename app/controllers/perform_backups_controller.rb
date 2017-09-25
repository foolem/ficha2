class PerformBackupsController < ApplicationController
before_action :set_perform_backup, only: [:show, :edit, :update, :destroy]

  # GET /perform_backups
  # GET /perform_backups.json
  def index
    @perform_backups = PerformBackup.all
    @perform_backup = PerformBackup.first
    @perform_backup.time = "#{@perform_backup.time.hour}:#{@perform_backup.time.min}"

  end

  def new

  end

  def show
  end

  def edit
  end

  def update
    time_hour = @perform_backup.time.hour
    if time_hour >= 12
      day_or_night = 'pm'
    elsif time_hour < 12
      day_or_night = 'am'
    end
    days = @perform_backup.days
    time = "#{@perform_backup.time.hour}:#{@perform_backup.time.min}"
    File.write('config/schedule.rb', "every #{days}.day, :at => '#{time} #{day_or_night}' do\n
    command \"backup perform -t backupDB\"\n
    end")
    puts days
    puts time
    if @perform_backup.update(perform_backup_params)
    respond_to do |format|
        format.html { redirect_to perform_backups_path, notice: 'Agendamento de backup atualizado.' }
      end
    end
    update_cron = `whenever --update-crontab`
  end

  def destroy
  end

  def do_perform
    perform =  `backup perform -t backupDB`
    respond_to do |format|
      format.js
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def perform_backup_params
      params.require(:perform_backup).permit(:days, :time)
    end
    def set_perform_backup
      @perform_backup = PerformBackup.find(params[:id])
    end
end
