module OmniauthHelpers
  def oauth_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '1',
      info: {
        name: 'facebookname',
        email: 'facebook@test.com'
      }
    )
  end

  def oauth_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '1',
      info: {
        nickname: 'githubname',
        email: 'github@test.com'
      }
    )
  end
end
