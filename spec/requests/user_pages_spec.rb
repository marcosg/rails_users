require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All Users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      sign_in user
      visit edit_user_path(user) 
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Update User Account" }

      it { should have_content('review the problems') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "User name",        with: new_name
        fill_in "Email",            with: new_email
        fill_in "New password",     with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Update User Account"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end

  describe "forbidden actions" do
    describe "admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin, no_capybara: true
      end

      it "should not be able to delete himself" do
        expect do
          delete user_path(admin)
        end.not_to change(User, :count)
      end
    end
  end
end