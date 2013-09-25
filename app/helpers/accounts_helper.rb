module AccountsHelper

  CHARS = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
  def generate_securish_uuid(length = 40)
    Array.new(length) { CHARS[SecureRandom.random_number(CHARS.length)] }.join
  end

  def generate_random(purpose = nil, length = 4)
    slug = ''
    slug << purpose << '-' if purpose
    slug << generate_securish_uuid(length)
    slug
  end



end
