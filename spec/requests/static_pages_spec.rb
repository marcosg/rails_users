require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(page_title) }
  end

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
        should have_content('Ayuda')
      end          

      describe "and follow a link" do
        before do 
          click_link "Contactar"
          #puts "clicked_link Contactar: #{current_path}"
        end
        
        it "should have_content('Contactar')" do
          should have_content('Contactar')
        end
      end
    end
    after { visit root_path(locale: "en") }
  end

  describe "Home page" do
    before { visit root_path }

    let(:heading)    { 'VetRx' }
    let(:page_title) { 'VetRx' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
  end


  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About VetRx' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title('About VetRx')
    click_link "Help"
    expect(page).to have_title('Help')
    click_link "Contact"
    expect(page).to have_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title('Sign up')
    click_link "VetRx"
    expect(page).to have_title('VetRx')
  end
end