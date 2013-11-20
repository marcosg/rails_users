require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Language links" do
    before do
      visit help_path
    end

    it do 
      should have_content('Help') 
    end

    describe "switch to Spanish" do
      before do 
        click_link "Español"
      end

      it do 
        #puts "clicked_link Español: #{current_path}"
        should have_content('Ayuda')
      end          

      describe "and follow a link" do
        before do 
          click_link "Contactar"
          #puts "click_link Contactar: #{current_path}"
        end
        
        it "should have_content('Contactar')" do
          pending "preserve non-default relative paths in test"
        end
      end
    end
  end

  describe "Home page" do
    before { visit root_path }

    it { should have_content('VetRx') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }
  end


  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title(full_title('About VetRx')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end
end