require 'hashr'

module Pendaxes
  class Config < Hashr
    define detection: {use: :rspec},
           workspace: nil,
           report: {use: :text, to: "report.txt"},
           notifications: [{use: :terminal}]
  end
end
