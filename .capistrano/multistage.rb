# Handles multistage configuration
class Config
  attr_reader :config
  attr_reader :stages

  def initialize(config)
    @config = config
    @stages = []
  end

  def stage(name, options={})
    stages << Stage.new(name, options)
  end
end

class Stage
  attr_reader :name
  attr_reader :options

  def initialize(name, options={})
    @name    = name
    @options = options
  end
end

set :multistage_config, Config.new(nil)

def define_stage(*args, &block)
  warn "[DEPRECATION] `define_stage` is deprecated, use `stage` instead"
  stage(*args, &block)
end

def stage(name, options={}, &block)
  set :default_stage, name.to_sym if options.delete(:default)
  multistage_config.stage(name, options)
  callbacks[:start].detect { |c| c.source == 'multistage:ensure' }.except << name.to_s

  task(name) do
    set :current_stage, name.to_s
    options.each do |k, v|
      set k, v if v
    end
    block.call if block
  end
end

namespace :multistage do
  task :ensure do
    unless exists?(:current_stage)
      stage_names = multistage_config.stages.map(&:name)
      abort "\n   err :: No stage specified. Please specify one of the following stages (e.g. `cap #{stage_names.first} #{ARGV.last}'):\n\n    #{stage_names.join('\n    ')}\n\n"
    end
  end
end

on :start, 'multistage:ensure'
