module UsersHelper
# Returns the Gravatar (http://gravatar.com/) for the given user.
def gravatar_for(user)
gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
image_tag(gravatar_url, alt: user.name, class: "gravatar")
end

def gravatar_for_with_size_course_box(user, s)
                gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
                gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
                image_tag(gravatar_url, alt: user.name, class: "img-rounded", size: s,style: "border-radius:5px;margin: 8px 0 6px -45px;width:56%;")
end
def gravatar_for_with_size(user, s)
                gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
                gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
                image_tag(gravatar_url, alt: user.name, class: "img-rounded", size: s)
        end

end
                     