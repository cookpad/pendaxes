require_relative './spec_helper'
require 'pendaxes/defaults'

describe Pendaxes::Defaults do
  subject { Class.new { extend Pendaxes::Defaults } }

  describe "#defaults" do
    context "with no argument" do
      it "returns current defaults" do
        subject.defaults.should == {}
      end
    end

    context "with argument" do
      it "sets defaults"  do
        subject.defaults :a => :b
        subject.defaults.should == {:a => :b}
      end
    end

    context "with superclass" do
      let(:superclass) { Class.new { extend Pendaxes::Defaults }.tap{|klass| klass.defaults :a => :b } }
      subject { Class.new(superclass) { extend Pendaxes::Defaults } }

      context "without argument (first time)" do
        it "returns superclass' default" do
          subject.defaults.should == {:a => :b}
        end
      end

      context "with argument" do
        it "merges into superclass' defaults" do
          subject.defaults :b => :c
          subject.defaults.should == {:a => :b, :b => :c}
          subject.defaults :b => :d
          subject.defaults.should == {:a => :b, :b => :d}
        end
      end
    end
  end
end
