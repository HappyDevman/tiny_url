class Link < ApplicationRecord
  validates :original_url, presence: true, format: URI::regexp(%w[http https])

  after_create :create_short_url

  def create_short_url
    self.short_url = Link.url_encode(id)
    save
  end

  private

  class << self
    def url_encode(id)
      return alphabet[0] if id == 0

      s = ''
      base = alphabet.length
      while id > 0
        s << alphabet[id.modulo(base)]
        id /= base
      end
      s.reverse
    end

    def alphabet
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split(//)
    end
  end
end
