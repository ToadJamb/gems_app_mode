# Add a task to run all tests.
Rake::TestTask.new('tests') do |task|
  task.pattern = 'test/*_test.rb'
  task.verbose = true
  task.warning = true
end
Rake::Task[:tests].comment = 'Run all tests'

################################################################################
namespace :test do
################################################################################
  file_list = Dir['test/*_test.rb']

  # Add a distinct test task for each test file.
  file_list.each do |item|
    # Get the name to use for the task by removing '_test.rb' from the name.
    task_name = File.basename(item, '.rb').gsub(/_test$/, '')

    # Add each test.
    Rake::TestTask.new(task_name) do |task|
      task.pattern = item
      task.verbose = true
      task.warning = true
    end
  end
################################################################################
end # :test
################################################################################
