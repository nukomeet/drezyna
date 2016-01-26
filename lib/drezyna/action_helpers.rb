module Drezyna 
  module ActionHelpers

    def configure_environment(rails_env, config)
      inject_into_file("config/environments/#{rails_env}.rb",
                       "\n\n  #{config}", before: "\nend")
    end

    def replace_in_file(relative_path, find, replace)
      path = File.join(destination_root, relative_path)
      contents = IO.read(path)
      unless contents.gsub!(find, replace)
        raise "#{find.inspect} not found in #{relative_path}"
      end
      File.open(path, "w") { |file| file.write(contents) }
    end

    def oauth_methods
      <<-RUBY
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email
      email = auth.info.email if email_is_verified
      user = User.where(email: email).first if email

      # Create the user if it's a new registration
      if user.nil?
        attrs = auth.extra.raw_info.slice("name", "first_name", "last_name").to_h
        user = User.new(attrs.merge(email: email ? email : [TEMP_EMAIL_PREFIX, auth.uid, auth.provider].join('-') + '.com',
                                    remote_picture_url: auth.info.image.present? ? extract_picture_url(auth) : nil,
                                    password: Devise.friendly_token[0,20]))
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end

    user
  end
RUBY
    end
  end
end
