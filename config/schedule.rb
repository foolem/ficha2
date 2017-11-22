every 1.day, :at => '10:0 am' do

      command "backup perform --trigger backup_database --config-file ~/ficha2/backup/config.rb"

      end