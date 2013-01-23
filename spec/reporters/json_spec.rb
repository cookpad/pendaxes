require_relative '../spec_helper'
require 'json'
require 'pendaxes/reporters/json'

describe Pendaxes::Reporter::JSON do
  it "has Pendaxes::Reporter as superclass" do
    described_class.superclass.should == Pendaxes::Reporter
  end

  describe "#report" do
    subject { described_class.new }
    let!(:now) { Time.now }

    let(:pends) do
      [
        {commit:  {sha: 'a', name: 'foo', email: 'foo@example.com', at: (now-86400)},
         example: {file: 'a_spec.rb', line: 10, message: "pending 'because it fails'"}, allowed: true},
        {commit:  {sha: 'b', name: 'foo', email: 'foo@example.com', at: (now-864000)},
         example: {file: 'a_spec.rb', line: 15, message: "pending 'because it fails.'"}, allowed: false}
      ]
    end

    before do
      subject.add(pends)
    end

    it "reports in JSON" do
      subject.report.should == \
        {pendings: pends.sort_by { |_| _[:commit][:at] }}.to_json
    end
  end
end
