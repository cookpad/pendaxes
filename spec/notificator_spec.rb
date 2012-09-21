require_relative './spec_helper'
require 'pendaxes/notificator'
require 'pendaxes/reporter'

describe Pendaxes::Notificator do
  it "has included Defaults" do
    described_class.singleton_class.included_modules.include?(Pendaxes::Defaults).should be_true
  end

  it "has included PendingManager" do
   described_class.included_modules.include?(Pendaxes::PendingManager).should be_true
  end

  it "responds to #notify" do
    described_class.new.should be_respond_to(:notify)
  end

  describe "#report_for" do
    let(:reporter) do
      Class.new(Pendaxes::Reporter) do
        def report
          [@config, @pendings]
        end
      end
    end

    let(:fixture) do
      [{commit: {:sha => 'a'}, example: {:file => 'a'}, allowed: true}, {commit: {:sha => 'b'}, example: {:file => 'b'}, allowed: false}]
    end

    before do
      Pendaxes::Reporter.announce(:report_for, reporter)
    end

    subject { described_class.new(reporter: {name: :report_for, foo: :bar}) }

    it "returns report using reporter specified by config" do
      subject.report_for(fixture).should == [{name: :report_for, foo: :bar, include_allowed: true}, fixture]
    end
  end
end
