require 'hashr'

module Pendaxes
  class Config < Hashr
    define detection: {use: :rspec},
           workspace: nil,
           reporter: {use: :text, to: "report.txt", include_allowed: false},
           notifications: [{use: :terminal, include_allowed: true}]
  end
end
