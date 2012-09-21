require 'hashr'

module Pendaxes
  class Config < Hashr
    define detection: {name: :rspec, pattern: "spec/**/*_spec.rb", allowed_for: 604800},
           workspace: {directory: "."},
           report: {name: :text, to: "report.txt"},
           notifications: [{name: :terminal}]
  end
end
