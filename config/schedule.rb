every 1.day, :at => '18:30 pm' do

      command "backup perform --trigger backup_database --config-file /app/backup/config.rb"

      end