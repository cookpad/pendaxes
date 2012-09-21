require_relative '../spec_helper'
require 'pendaxes/detectors/rspec'

describe Pendaxes::Detector::RSpec do
  it "has Pendaxes::Detector as superclass" do
    described_class.superclass.should == Pendaxes::Detector
  end

  describe "#detect" do
    it "returns Array"

    describe "detecting" do
      it "detects pendings in all files"

      it "marks pending as not allowed if committed after than :allowed_for"

      context "with :pattern" do
        it "uses that as git-grep as pattern"
      end
    end
  end
end
