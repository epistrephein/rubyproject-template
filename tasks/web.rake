# frozen_string_literal: true

namespace :web do
  WEB_DIR        = ROOT_DIR.join('web')
  PUBLIC_DIR     = WEB_DIR.join('public')

  TEMPLATE_FILE  = WEB_DIR.join('template.html.erb')
  VARIABLES_FILE = WEB_DIR.join('variables.yml')
  GENERATED_FILE = PUBLIC_DIR.join('index.html')

  desc 'Build webpage'
  task build: :environment do |_task|
    require 'erb'

    erb  = ERB.new(File.read(TEMPLATE_FILE))
    vars = YAML.load_file(VARIABLES_FILE)

    File.write(GENERATED_FILE, erb.result_with_hash(vars))

    Logger.stdout.info(task) { "Building #{GENERATED_FILE}" }
  end

  desc 'Serve webpage'
  task :serve do |_task|
    require 'webrick'

    server = WEBrick::HTTPServer.new(Port: 8080, DocumentRoot: PUBLIC_DIR)

    Signal.trap('INT') { server.shutdown }
    server.start
  end
end
