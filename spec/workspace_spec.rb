require_relative './spec_helper'
require 'pendaxes/workspace'

describe Pendaxes::Workspace do
  describe "#clone" do
    it "clones a repository"

    context "if :directory isn't exist" do
      it "mkdirs"
    end

    context "if repository already cloned" do
      it "removes then clone again"
    end
  end

  describe "#update" do
    it "fetchs"

    it "resets --hard"
  end

  describe "#path" do
    it "returns the path to working copy"
  end

  describe "#dive" do
    it "yields in Dir.chdir"
  end

  describe "#git" do
    it "invokes git"
  end
end


