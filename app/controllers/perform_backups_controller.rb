class PerformBackupsController < ApplicationController
before_action :set_perform_backup, only: [:edit, :update, :index]
before_action :bar_define

  # GET /perform_backups
  # GET /perform_backups.json
  def index
    @perform_backups = PerformBackup.all

  end

  def update
    if @perform_backup.update(perform_backup_params)
      time_hour = @perform_backup.time.hour
      days = @perform_backup.days
      time = "#{@perform_backup.time.hour}:#{@perform_backup.time.min}"
      if time_hour >= 12
        day_or_night = 'pm'
      elsif time_hour < 12
        day_or_night = 'am'
      end
      File.write('config/schedule.rb', "every #{days}.day, :at => '#{time} #{day_or_night}' do\n
      command \"backup perform -t backupDB\"\n
      end")
      update_cron = `whenever --update-crontab`
      respond_to do |format|
        format.html { redirect_to perform_backups_path, notice: 'Agendamento de backup atualizado.' }
      end
    end
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
      @perform_backup = PerformBackup.first
      if (@perform_backup.blank?)
        @perform_backup = PerformBackup.create(days: "1", time: "2000-01-01 13:30:00")
        if @perform_backup.time.hour >= 12
          day_or_night = 'pm'
        elsif @perform_backup.time.hour < 12
          day_or_night = 'am'
        end
        File.write('config/schedule.rb', "every #{@perform_backup.days}.day, :at => '#{@perform_backup.time.hour}:#{@perform_backup.time.min} #{day_or_night}' do\n
        command \"backup perform -t backupDB\"\n
        end")
        update_cron = `whenever --update-crontab`
      end
    end

    def bar_define
      session[:page] = "perform_backups"
    end
end
