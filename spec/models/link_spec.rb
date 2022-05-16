require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://github.com/').for(:url) }
  it { should_not allow_value('something_wrong_url').for(:url) }
end

#rspec spec/models/link_spec.rb