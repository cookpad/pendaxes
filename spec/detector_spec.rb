require_relative './spec_helper'
require 'pendaxes/detector'

describe Pendaxes::Detector do
  it "has included Defaults" do
    described_class.singleton_class.included_modules.include?(Pendaxes::Defaults).should be_true
  end

  it "responds to #detect" do
    described_class.new(Pendaxes::Workspace.new).should be_respond_to(:detect)
  end
end
