require_relative './spec_helper'
require 'pendaxes/notificator'

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
    it "returns report using reporter specified by config"
  end
end
