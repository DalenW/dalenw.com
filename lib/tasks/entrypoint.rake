namespace :entrypoint do
  desc "Entrypoint for the application"
  task init: :environment do
    # migrate the database
    # Rake::Task["db:drop"].invoke
    # Rake::Task["db:create"].invoke
    Rake::Task["db:migrate:with_data"].invoke

    puts "Removing PID"
    File.delete("/onac-app/tmp/pids/server.pid") if File.exist?("/onac-app/tmp/pids/server.pid")

    # start the web server
    puts "Starting web server"
    system("bundle exec rails s -b 0.0.0.0 -p 3000")
  end
end
