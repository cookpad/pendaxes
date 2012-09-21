require_relative './spec_helper'
require 'pendaxes/pending_manager'
require 'hashr'

describe Pendaxes::PendingManager do
  class Manager
    include Pendaxes::PendingManager

    def initialize(config={})
      @config = Hashr.new(config)
      @pendings = []
    end
  end

  subject { Manager.new }

  describe "#add" do
    before { subject.add(commit: {:sha => 'a'}, example: {:file => 'a'}, allowed: false) }

    it "adds pendings" do
      subject.all_pendings.size.should == 1
      subject.all_pendings.first[:commit][:sha].should == 'a'
      subject.all_pendings.first[:example][:file].should == 'a'
    end

    context "with Array" do
      let(:fixture) { [{commit: {:sha => 'b'}, example: {:file => 'b'}, allowed: true}, {commit: {:sha => 'c'}, example: {:file => 'c'}, allowed: false}] }

      before do
        subject.add(fixture)
      end

      it "adds all as pending" do
        subject.all_pendings.last(2).should == fixture
      end
    end
  end

  describe "#pendings" do
    before do
      subject.add(commit: {:sha => 'a'}, example: {:file => 'a'}, allowed: true)
      subject.add(commit: {:sha => 'b'}, example: {:file => 'b'}, allowed: false)
    end

    it "returns pendings exclude allowed" do
      subject.pendings.size.should == 1
      subject.pendings.first[:commit][:sha].should == 'b'
      subject.pendings.first[:example][:file].should == 'b'
    end

    context "with config[:include_allowed]" do
      subject { Manager.new(Hashr.new(:include_allowed => true)) }

      it "returns pendings include allowed" do
        subject.pendings.size.should == 2

        subject.pendings[0][:commit][:sha].should == 'a'
        subject.pendings[0][:example][:file].should == 'a'

        subject.pendings[1][:commit][:sha].should == 'b'
        subject.pendings[1][:example][:file].should == 'b'
      end

    end
  end

  describe "#all_pendings" do
    before do
      subject.add(commit: {:sha => 'a'}, example: {:file => 'a'}, allowed: true)
      subject.add(commit: {:sha => 'b'}, example: {:file => 'b'}, allowed: false)
    end

    it "returns pendings with not allowed" do
      subject.all_pendings.size.should == 2

      subject.all_pendings[0][:commit][:sha].should == 'a'
      subject.all_pendings[0][:example][:file].should == 'a'

      subject.all_pendings[1][:commit][:sha].should == 'b'
      subject.all_pendings[1][:example][:file].should == 'b'
    end
  end


  describe "#reset" do
    before do
      subject.add(commit: {:sha => 'a'}, example: {:file => 'a'}, allowed: true)
      subject.add(commit: {:sha => 'b'}, example: {:file => 'b'}, allowed: false)
      subject.reset
    end

    it "removes all pendings that added" do
      subject.all_pendings.should be_empty
      subject.pendings.should be_empty
    end
  end
end
