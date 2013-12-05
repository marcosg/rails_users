require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_content(user.organization) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_title('Sign up') }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create User Account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe "after submit" do
        before do 
          fill_in "Email",             with: "invalid Email"          
          fill_in "Password",          with: "short", match: :prefer_exact        
          fill_in "Confirm Password",  with: "wrong password"          
          click_button submit
        end

        it "should have errors" do 
          should have_title('Sign up') 
          should have_content('problems below')
          should have_content("can't be blank")
          should have_content('is invalid')
          should have_content('is too short')
          should have_content("doesn't match Password")
        end
      end      
    end

    describe "with valid information" do
      before do
        fill_in "User name",        with: "Happy Example"
        fill_in "Organization",     with: "Happy Example"
        fill_in "Email",            with: "hexample@example.com"
        fill_in "Password",         with: "password", match: :prefer_exact
        fill_in "Confirm Password", with: "password"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'hexample@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_success_message('created') }
        describe "followed by signout" do
          before { click_link "Sign out" }

          it { should have_link('Sign in') }
        end          
      end  
    end
  end
end