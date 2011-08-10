desc 'Generate examples.'
task :examples do |task|
  require "./lib/#{File.basename(Dir.getwd)}"

  commands = [
    [
      'StateManager.new',
      'StateManager.new(:test)',
      'StateManager.new(:dev, [:abc, :dev])',
    ], [
    'o=StateManager.new;o.state',
    ]
  ]

  output = []

  commands.each do |sub_commands|
    max = 0

    sub_commands.each do |command|
      output << generate_output(command)
      max = [output.last.index(/%s/), max].max
    end

    output.map! do |item|
      item % [' ' * (max - (item.index(/%s/) || 0) + 1)]
    end
  end

  puts output
end

def generate_output(command)
  format = '%s%s#=> %s'

  result = eval(command)

  if result.inspect =~ /^#</
    result = result.inspect
    result.gsub!(/^#|:\wx\w{14}/, '')
  end

  return format % [command, '%s', result]
end
