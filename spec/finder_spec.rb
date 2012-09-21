require_relative './spec_helper'
require 'pendaxes/finder'

describe Pendaxes::Finder do
  subject { Class.new { extend Pendaxes::Finder } }

  describe ".find" do
    let(:klass) { Class.new(subject) }

    context "with String" do
      it 'requires that' do
        subject.should_receive(:require).with("foo/bar/baz")

        subject.find('foo/bar/baz')
      end
    end

    context "with Symbol" do
      it 'requires that' do
        subject.should_receive(:require).with("foo")
        subject.find(:foo)
      end
    end

    it "requires file and return included ancestor" do
      subject.should_receive(:require).with("foo") do
        klass; true
      end
      subject.find(:foo).should == klass
    end

    context "on second time" do
      it "requires once" do
        subject.should_receive(:require).with("foo").once do
          klass; true
        end
        subject.find(:foo).should == klass
        subject.find(:foo).should == klass
      end
    end
  end

  describe ".find_in" do
    subject do
      Class.new do
        extend Pendaxes::Finder
        find_in "hoge"
      end
    end

    it 'makes Finder.find(Symbol) to use as prefix for require' do
      subject.should_receive(:require).with("hoge/foo")
      subject.find(:foo)
    end
  end
end
