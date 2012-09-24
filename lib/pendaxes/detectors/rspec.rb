# coding: utf-8
require_relative '../detector'
require 'time'
require 'ripper'
require 'ripper/lexer'

module Pendaxes
  class Detector
    class RSpec < Detector
      PENDERS = %w(xit xexample xspecify pending).freeze
      GREP_CMD = ( %w(grep --name-only -e) \
                 + PENDERS.join(' --or -e ').split(/ /) \
                 + ['--']
                 ).freeze
      PARENTS = %w(context describe it example specify xexample xspecify xit).freeze

      defaults pattern: '*_spec.rb'

      def detect
        @workspace.dive do
          pattern = @config.pattern.is_a?(Array) ? @config.pattern : [@config.pattern]
          grep = @workspace.git(*GREP_CMD, *pattern).force_encoding("UTF-8")
          return [] unless grep
          files = grep.split(/\r?\n/).map(&:chomp)

          files.inject([]) do |pendings, file|
            @config.out.puts "* #{file}" if @config.out
            file_content = File.read(file).force_encoding(@config.encoding || "UTF-8")
            lines = file_content.split(/\r?\n/)
            tokens = Ripper.lex(file_content, file)
            _prev = nil

            tokens.each_with_index do |token, i|
              prev = _prev
              _prev = token[1]
              next if prev == :on_symbeg
              next unless token[1] == :on_ident && PENDERS.include?(token[2])
              pending = {}

              line = token[0][0]

              parent = (i-1).downto(0).inject {|_, j|
                break lines[tokens[j][0][0]-1] if tokens[j][1] == :on_ident && (j.zero? || tokens[j-1][1] != :on_symbeg) && PARENTS.include?(tokens[j][2])
                nil
              }
              parent.gsub!(/^[ \t]+/, '') if parent

              pending[:example] = {
                file: file, line: line,
                message: lines[line-1].gsub(/^[ \t]+/, ''), parent: parent
              }

              pending[:commit] = blame(file, line)
              pending[:allowed] = (Time.now - pending[:commit][:at]) <= @config.allowed_for

              pendings << pending
            end

            pendings
          end
        end
      end

      private

      def blame(file, line)
        @config.out.puts "  * blaming #{file}:#{line}" if @config.out
        blame = @workspace.git('blame', '-L', "#{line},#{line}", '-l', '-w', '-p', file).force_encoding("UTF-8").split(/\r?\n/).map{|l| l.split(/ /) }
        commit = {
          sha: blame[0].first, name: blame[1][1..-1].join(' '),
          email: blame[2][1..-1].join(' ').gsub(/^</,'').gsub(/>$/,'')
        }
        commit[:at] = Time.parse(@workspace.git(*%w(log --pretty=%aD -n1), commit[:sha]).chomp)
        commit
      end
    end
  end
end
