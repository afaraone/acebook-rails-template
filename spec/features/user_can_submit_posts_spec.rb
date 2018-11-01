require 'rails_helper'
require 'timecop'

RSpec.feature "Timeline", type: :feature do
  before do
    sign_up_correct_helper
  end

  context "Creating a new post" do
    before do
      Timecop.freeze(Time.zone.parse('13:00 3 October 2018'))
      create_post("Hello, world!")
    end

    scenario "Can submit posts and view them" do
      expect(find('p#1.post-message')).to have_content("Hello, world!")
    end

    scenario 'Posts have authors name' do
      expect(find('.post-author')).to have_content('TestName')
    end

    scenario "Posts have a timestamp" do
      expect(find('p#1.post-timestamp')).to have_content("Wednesday, 3 Oct 2018 at 1:00 PM")
    end

    scenario "Posts appear in reverse chronological order" do
      Timecop.freeze(Time.zone.parse('13:00 4 October 2018'))
      create_post("Second Post")
      expect(first('p.post-message')).to have_content("Second Post")
    end

    scenario 'Posts can not be longer than 500 words' do
      string = "a" * 501
      create_post(string)
      expect(first('p.post-message')).not_to have_content(string)
    end
  end
end
