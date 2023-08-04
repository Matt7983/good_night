require 'oj'

Blueprinter.configure do |config|
  config.generator = Oj
  config.sort_fields_by = :definition
  # config.datetime_format = ->(d) { d.nil? ? d : d.strftime('%s').to_i }
end
