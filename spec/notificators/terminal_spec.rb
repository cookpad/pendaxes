require_relative '../spec_helper'
require 'pendaxes/notificators/terminal'
require 'stringio'

describe Pendaxes::Notificator::Terminal do
  it "has Pendaxes::Notificator as superclass" do
    described_class.superclass.should == Pendaxes::Notificator
  end

  describe "#notify" do
    let(:io) { StringIO.new }
    let(:config) { {to: io} }
    let(:now) { Time.now }
    let(:fixture) do
      [
        {commit:  {sha: 'a', name: 'foo', email: 'foo@example.com', at: (now-86400)},
         example: {file: 'a_spec.rb', line: 10, message: "pending 'because it fails'"}, allowed: true},
        {commit:  {sha: 'b', name: 'foo', email: 'foo@example.com', at: (now-864000)},
         example: {file: 'a_spec.rb', line: 15, message: "pending 'because it fails.'"}, allowed: false},
        {commit:  {sha: 'c', name: 'bar', email: 'bar@example.com', at: (now-86400)},
         example: {file: 'a_spec.rb', line: 20, message: "pending 'because it fails..'"}, allowed: true},
        {commit:  {sha: 'd', name: 'bar', email: 'bar@example.com', at: (now-864000)},
         example: {file: 'a_spec.rb', line: 25, message: "pending 'because it fails...'"}, allowed: false},
      ]
    end

    subject { described_class.new(config) }

    before do
      subject.add(fixture)
      subject.notify
    end

    it "notifies into terminal" do
      out = io.string
      out.should == <<-EOF
foo <foo@example.com>:

* a_spec.rb:15 - pending 'because it fails.' (@ b #{now-864000})

bar <bar@example.com>:

* a_spec.rb:25 - pending 'because it fails...' (@ d #{now-864000})

      EOF
    end

    context "with :include_allowed" do
      let(:config) { {to: io, include_allowed: true} }
      it "notifies all into terminal" do
        out = io.string
        out.should == <<-EOF
foo <foo@example.com>:

* a_spec.rb:15 - pending 'because it fails.' (@ b #{now-864000})
* a_spec.rb:10 - pending 'because it fails' (@ a #{now-86400})

bar <bar@example.com>:

* a_spec.rb:25 - pending 'because it fails...' (@ d #{now-864000})
* a_spec.rb:20 - pending 'because it fails..' (@ c #{now-86400})

        EOF
      end
    end
  end
end
