require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Splash Page" do

    before { visit root_path }


    it "should have a title" do
      # save_and_open_page
      subject.source.should have_selector('title', text: "Odin") 
    end

    it { should have_selector('h1', text: "Odin") }

    describe "filling in the email form" do
      before(:each) do
        fill_in("splash_email_email", with: "foo@bar.com")
      end

      it "should create the splash_email instance" do
        expect { click_button("commit") }.to change(SplashEmail, :count).by(1)
      end

      describe "after form submission" do
        before(:each) do
          click_button("commit")
        end

        it "should redirect to the thank_you page" do
          subject.should have_selector('h2', text: "Thank you!")
        end
      end
    end

  end

  describe "Thank You Page" do

    before { visit thank_you_path }
    let(:suggestion_body){"testing123 123"}

    it { should have_selector('h2', text: "Thank you!") }

    describe "filling in the suggestion form" do
      before(:each) do
        ActionMailer::Base.deliveries = []  # Clear out other test deliveries
        # save_and_open_page
        fill_in("suggestion", with: suggestion_body)
      end

      context "after submitting the form" do
        before(:each) do
          click_button("commit")
        end

        it "should disable the form" do
          # fail.  Can't test AJAX/JS behavior easily...
        end
        it "should send an email request with the form contents" do
          ActionMailer::Base.deliveries.first.encoded.should include suggestion_body
        end
      end

    end


  end

end