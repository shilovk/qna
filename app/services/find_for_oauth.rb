class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.find_by(email: email) || create_user_by(email)
    create_authorization_for(user, auth)

    user
  end

  private

  def create_user_by(email)
    password = Devise.friendly_token[0, 20]
    user = User.create!(email: email, password: password, password_confirmation: password)
  end

  def create_authorization_for(user, auth)
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
