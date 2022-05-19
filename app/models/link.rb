class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  validates :name, :url, presence: true
  validates :url, format: URI::regexp

  GIST_ROOT_PATH = 'https://gist.github.com/'

  def gist?
    self.url.start_with?(GIST_ROOT_PATH)
  end
end
