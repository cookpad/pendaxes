require_relative '../spec_helper'
require 'pendaxes/notificators/mail'
require 'pendaxes/reporter'
require 'mail'

Mail.defaults do
  delivery_method :test
end

class TestReporter < Pendaxes::Reporter
  def report
    "Test reporting: #{pendings.inspect}"
  end
end

class TestHtmlReporter < TestReporter
  def self.html?; true; end
end


describe Pendaxes::Notificator::Mail do
  before(:all) do
    Pendaxes::Reporter.announce :test_reporter, TestReporter
    Pendaxes::Reporter.announce :test_html_reporter, TestHtmlReporter
  end

  let(:pendings) do
    [{
       example: {file: "spec/a_spec.rb", line: 9,
                 message: 'xit "d" do', parent: 'context "c" do'},
       commit:  {sha: '371955e233bf1ff42d0c7cca3510ec0f8d71ec8d',
                 name: 'Shota Fukumori', email: 'sorah@cookpad.com',
                 at: Time.parse('2012-09-21 16:44:13 +0900')},
       allowed: true
     },
     {
       example: {file: "spec/a_spec.rb", line: 4,
                 message: 'pending', parent: 'it "a" do'},
       commit:  {sha: '642caa033642700cd9d4c6f026fe73282985ed50',
                 name: 'Shota Fukumori', email: 'sorah@cookpad.com',
                 at: Time.parse('Thu, 7 Apr 2005 22:13:13 +0900')},
       allowed: false
     },
     {
       example: {file: "spec/b/c_spec.rb", line: 3,
                 message: 'pending', parent: 'it "d" do'},
       commit:  {sha: '49499865388dcbce14be3a8b7eca841538b29496',
                 name: 'Shohta Fukumori', email: 'sorah+b@cookpad.com',
                 at: Time.parse('Fri, 21 Sep 2012 16:43:43 +0900')},
       allowed: true
     }]
  end

  it "has Pendaxes::Notificator as superclass" do
    described_class.superclass.should == Pendaxes::Notificator
  end

  describe "#notify" do
    include Mail::Matchers
    let(:config_root) { {reporter: {use: :test_reporter}, from: "sorah+from@cookpad.com", include_allowed: true} }
    let(:config) { config_root }
    let(:deliveries) { Mail::TestMailer.deliveries }
    subject { described_class.new(config) }
    before { subject.add(pendings) }
    after { Mail::TestMailer.deliveries.clear }

    it "sends mails for each committers" do
      subject.notify

      deliveries.size.should == 2
      should have_sent_email.from('sorah+from@cookpad.com')
      should have_sent_email.to('sorah@cookpad.com')
      should have_sent_email.to('sorah+b@cookpad.com')
    end

    it "uses report as body of mail" do
      subject.notify

      %w(sorah@cookpad.com sorah+b@cookpad.com).each do |email|
        delivery = deliveries.find {|deliver| deliver.to.include? email }
        delivery.body.should == "Test reporting: #{pendings.select {|pending| pending[:commit][:email] == email}.inspect}"
      end
    end

    context "with :delivery_method" do
      let(:config) { config_root.merge(delivery_method: :test, delivery_options: {foo: :bar}) }

      it "uses that as delivery_method" do
        method = Mail.new.delivery_method
        Mail::Message.any_instance.should_receive(:delivery_method).with(:test, foo: :bar).at_least(:once)
        exception = Exception.new
        Mail::Message.any_instance.stub(:deliver) { raise exception }

        expect { subject.notify }.to raise_error(exception)
      end
    end

    context "with :to" do
      let(:config) { config_root.merge(to: 'sorah+c@cookpad.com') }

      it "sends all mails to that" do
        subject.notify

        deliveries.size.should == 1
        should have_sent_email.to('sorah+c@cookpad.com')
        deliveries.first.body.should == "Test reporting: #{pendings.inspect}"
      end
    end

    context "with :whitelist" do
      let(:config) { config_root.merge(whitelist: ['sorah@cookpad.com']) }

      it "won't send mail to addresses don't match" do
        subject.notify

        deliveries.size.should == 1
        should_not have_sent_email.to('sorah+b@cookpad.com')
        should have_sent_email.to('sorah@cookpad.com')
      end

      context "regex" do
        let(:config) { config_root.merge(whitelist: ['/^sorah@/']) }

        it "parses as Regexp" do
          subject.notify

          deliveries.size.should == 1
          should_not have_sent_email.to('sorah+b@cookpad.com')
          should have_sent_email.to('sorah@cookpad.com')
        end
      end
    end

    context "with :blacklist" do
      let(:config) { config_root.merge(blacklist: ['sorah+b@cookpad.com']) }

      it "won't send mail to addresses that match" do
        subject.notify

        deliveries.size.should == 1
        should_not have_sent_email.to('sorah+b@cookpad.com')
        should have_sent_email.to('sorah@cookpad.com')
      end

      context "regex" do
        let(:config) { config_root.merge(blacklist: ['/^sorah\+/']) }

        it "parses as Regexp" do
          subject.notify

          deliveries.size.should == 1
          should_not have_sent_email.to('sorah+b@cookpad.com')
          should have_sent_email.to('sorah@cookpad.com')
        end
      end
    end

    context "with :whitelist & :blacklist" do
      let(:config) { config_root.merge(whitelist: [/@cookpad\.com$/], blacklist: ['sorah+b@cookpad.com']) }

      it "prefers blacklist first" do
        subject.notify

        deliveries.size.should == 1
        should_not have_sent_email.to('sorah+b@cookpad.com')
        should have_sent_email.to('sorah@cookpad.com')
      end
    end

    context "when reporter's html is false" do
      it "sends mail as plain text" do
        deliveries.all? {|delivery| delivery.content_type == nil }.should be_true
      end
    end

    context "when reporter's html is true" do
      let(:config) { {reporter: {use: :test_html_reporter} } }

      it "sends mail as text/html" do
        deliveries.all? {|delivery| delivery.content_type == 'text/html; charset=utf-8' }.should be_true
      end
    end
  end
end
