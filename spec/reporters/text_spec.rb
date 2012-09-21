require_relative '../spec_helper'
require 'pendaxes/reporters/text'

describe Pendaxes::Reporter::Text do
  it "has Pendaxes::Reporter as superclass" do
    described_class.superclass.should == Pendaxes::Reporter
  end

  describe "#report" do
    it "returns String"

    it "reports added pendings"

    it "reports older pending first"
  end
end
