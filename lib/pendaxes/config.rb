require 'hashr'

module Pendaxes
  class Config < Hashr
    define detection: {use: :rspec},
           workspace: {},
           report: {use: :text, to: "report.txt"},
           notifications: [{use: :terminal}]
  end
end
