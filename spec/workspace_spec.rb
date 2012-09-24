require_relative './spec_helper'
require 'pendaxes/workspace'
require 'fileutils'

describe Pendaxes::Workspace do
  let(:repository) { "#{File.dirname(__FILE__)}/../fixtures/repo" }
  let(:config) { {path: "/tmp/repo", repository: repository} }

  subject do
    described_class.new(config)
  end

  describe "#clone" do
    it "clones a repository" do
      File.stub(:exist? => false)
      subject.should_receive(:git).with("clone", repository, "/tmp/repo")

      subject.clone
    end

    context "if repository already cloned" do
      before do
        File.stub(:exist? => true)
      end

      it "removes then clone again" do
        FileUtils.should_receive(:remove_entry_secure).with("/tmp/repo").ordered
        subject.should_receive(:git).with("clone", repository, "/tmp/repo")
        subject.clone
      end
    end
  end

  describe "#update" do
    before { File.stub(:exist? => true) }

    it "fetch and reset" do
      subject.should_receive(:dive).and_yield.ordered
      subject.should_receive(:git).with("fetch", "origin").ordered
      subject.should_receive(:git).with("reset", "--hard", "FETCH_HEAD").ordered

      subject.update
    end

    context "if not cloned yet" do
      before do
        File.stub(:exist? => false)
      end

      it "clones first" do
        subject.should_receive(:clone).ordered
        subject.should_receive(:dive).and_yield.ordered
        subject.should_receive(:git).with("fetch", "origin").ordered
        subject.should_receive(:git).with("reset", "--hard", "FETCH_HEAD").ordered

        subject.update
      end
    end

    context "with config.branch" do
      let(:config) { {directory: "/tmp/repo", repository: repository, branch: "topic"} }

      it "resets to specified branch" do
        subject.should_receive(:dive).and_yield.ordered
        subject.should_receive(:git).with("fetch", "origin").ordered
        subject.should_receive(:git).with("reset", "--hard", "topic").ordered

        subject.update
      end
    end
  end

  describe "#path" do
    it "returns the path to working copy" do
      subject.path.should == "/tmp/repo"
    end
  end

  describe "#dive" do
    it "yields in Dir.chdir(path)" do
      Dir.should_receive(:chdir).with(subject.path).and_yield

      flag = false
      subject.dive { flag = true }
      flag.should be_true
    end
  end

  describe "#git" do
    it "invokes git" do
      IO.should_receive(:popen).with(["git", "a", "b", "c"], 'r').and_return(:foo)
      subject.git("a", "b", "c").should == :foo
    end

    context "if git failed" do
      before do
        IO.stub(popen: '')
        $?.stub(success?: false)
      end

      it "returns nil" do
        subject.git('a').should be_nil
      end
    end

    context "with config.git" do
      let(:config) { {directory: "/tmp/repo", repository: repository, git: "/path/to/git"} }

      it "invokes specified git" do
        IO.should_receive(:popen).with(["/path/to/git", "a", "b", "c"], 'r').and_return(:bar)
        subject.git("a", "b", "c").should == :bar
      end
    end
  end
end
