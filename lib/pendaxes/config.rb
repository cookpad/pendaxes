require 'hashr'

module Pendaxes
  class Config < Hashr
    define detection: {name: :rspec},
           workspace: {},
           report: {name: :text, to: "report.txt"},
           notifications: [{name: :terminal}]
  end
end
