class Subdomain
  def self.matches?(request)
    request.subdomain.downcase.present? && request.subdomain.downcase != "www"
  end
end