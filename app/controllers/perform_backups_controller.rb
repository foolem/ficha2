class PerformBackupsController < ApplicationController


  # GET /perform_backups
  # GET /perform_backups.json
  def index
    @perform_backups = PerformBackup.all
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
      params.fetch(:perform_backup, {})
    end
end
