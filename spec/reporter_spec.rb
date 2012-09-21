
require_relative './spec_helper'
require 'pendaxes/reporter'

describe Pendaxes::Reporter do
  it "has included Defaults" do
    described_class.singleton_class.included_modules.include?(Pendaxes::Defaults).should be_true
  end

  it "has included PendingManager" do
   described_class.included_modules.include?(Pendaxes::PendingManager).should be_true
  end

  it "responds to #report" do
    described_class.new.should be_respond_to(:report)
  end

  describe "#html?" do
    it "returns false" do
      described_class.new.html?.should be_false
    end
  end
end
