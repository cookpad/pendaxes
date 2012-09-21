require_relative '../spec_helper'
require 'pendaxes/notificators/terminal'

describe Pendaxes::Notificator::Terminal do
  it "has Pendaxes::Notificator as superclass" do
    described_class.superclass.should == Pendaxes::Notificator
  end

  describe "#notify" do
    it "notifies into terminal"
  end
end
