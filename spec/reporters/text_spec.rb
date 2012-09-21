require_relative '../spec_helper'
require 'pendaxes/reporters/text'

describe Pendaxes::Reporter::Text do
  it "has Pendaxes::Reporter as superclass" do
    described_class.superclass.should == Pendaxes::Reporter
  end

  describe "#report" do
    subject { described_class.new }
    let!(:now) { Time.now }

    before do
      subject.add([
        {commit:  {sha: 'a', name: 'foo', email: 'foo@example.com', at: (now-86400)},
         example: {file: 'a_spec.rb', line: 10, message: "pending 'because it fails'"}, allowed: true},
        {commit:  {sha: 'b', name: 'foo', email: 'foo@example.com', at: (now-864000)},
         example: {file: 'a_spec.rb', line: 15, message: "pending 'because it fails.'"}, allowed: false}
      ])
    end

    it "reports added pendings" do
      subject.report.should be_include("a_spec.rb:10 - pending 'because it fails' (@ a #{now-86400})")
      subject.report.should be_include("a_spec.rb:15 - pending 'because it fails.' (@ b #{now-864000})")
    end

    it "reports older pending first" do
      subject.report.should == (<<-EOR).chomp
* a_spec.rb:15 - pending 'because it fails.' (@ b #{now-864000})
* a_spec.rb:10 - pending 'because it fails' (@ a #{now-86400})
      EOR
    end
  end
end
