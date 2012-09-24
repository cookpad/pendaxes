require_relative '../spec_helper'
require 'pendaxes/detectors/rspec'
require 'pendaxes/workspace'
require 'time'

describe Pendaxes::Detector::RSpec do
  it "has Pendaxes::Detector as superclass" do
    described_class.superclass.should == Pendaxes::Detector
  end

  describe "#detect" do
    before do
      Time.stub(now: Time.at(1348214400))
    end

    let(:repository) { File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'repo')) }
    let(:workspace) { Pendaxes::Workspace.new(repository: repository, path: repository) }
    let(:config) { {} }
    subject { described_class.new(workspace, config) }

    it "detects pendings in all files" do
      pendings = subject.detect
      pendings.size.should == 3

      xit = pendings.find {|pend| /xit/ === pend[:example][:message] }
      it_a = pendings.find {|pend| /pending$/ === pend[:example][:message] && pend[:example][:file] == "spec/a_spec.rb" }
      it_c = pendings.find {|pend| pend[:example][:file] == "spec/b/c_spec.rb" }
      # require 'pp'; pp pendings

      xit.should == {
        example: {file: "spec/a_spec.rb", line: 9,
                  message: 'xit "d" do', parent: 'context "c" do'},
        commit:  {sha: '371955e233bf1ff42d0c7cca3510ec0f8d71ec8d',
                  name: 'Shota Fukumori', email: 'sorah@cookpad.com',
                  at: Time.parse('2012-09-21 16:44:13 +0900')},
        allowed: true
      }
      it_a.should == {
        example: {file: "spec/a_spec.rb", line: 4,
                  message: 'pending', parent: 'it "a" do'},
        commit:  {sha: '642caa033642700cd9d4c6f026fe73282985ed50',
                  name: 'Shota Fukumori', email: 'sorah@cookpad.com',
                  at: Time.parse('Thu, 7 Apr 2005 22:13:13 +0900')},
        allowed: false
      }
      it_c.should == {
        example: {file: "spec/b/c_spec.rb", line: 3,
                  message: 'pending', parent: 'it "d" do'},
        commit:  {sha: '49499865388dcbce14be3a8b7eca841538b29496',
                  name: 'Shota Fukumori', email: 'sorah@cookpad.com',
                  at: Time.parse('Fri, 21 Sep 2012 16:43:43 +0900')},
        allowed: true
      }
    end

    context "with config.allowed_for" do
      let(:config) { {allowed_for: 0} }

      it "marks pending as not allowed if committed after than :allowed_for" do
        subject.detect.all? {|pending| !pending[:allowed] }.should be_true
      end
    end

    context "with :pattern" do
      let(:config) { {pattern: '*_test.rb'} }

      it "uses that as file pattern for git-grep" do
        pendings = subject.detect

        pendings.size.should == 1
        pendings.first[:example][:file].should match(/d_test\.rb$/)
      end
    end
  end
end
