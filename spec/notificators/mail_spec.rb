require_relative '../spec_helper'
require 'pendaxes/notificators/mail'
require 'mail'

Mail.defaults do
  delivery_method :test
end

describe Pendaxes::Notificator::Mail do
  it "has Pendaxes::Notificator as superclass" do
    described_class.superclass.should == Pendaxes::Notificator
  end

  describe "#notify" do
    it "sends mails for each committers"

    context "with :delivery_method" do
      it "uses that as delivery_method"

      context "and :delivery_options" do
        it "uses that as delivery_method's option"
      end
    end

    context "with :to" do
      it "sends all mails to that"
    end

    context "with :all_in_one" do
      it "won't separate mails for each committers"
    end

    context "with :whitelist" do
      it "won't send mail to addresses doesn't match"

      context "regex" do
        it "parses as Regexp"
      end
    end

    context "with :blacklist" do
      it "won't send mail to addresses does match"

      context "regex" do
        it "parses as Regexp"
      end
    end

    context "with :whitelist & :blacklist" do
      it "doesn't send mail if whitelisted and blacklisted"
    end

    context "with :reporter" do
      it "uses that as reporter"
    end
  end
end
