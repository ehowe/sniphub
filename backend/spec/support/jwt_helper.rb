RSpec.shared_context "jwt helper" do
  let(:local_user)       { defined?(user) ? user : create(:user) }
  let(:local_expiration) { defined?(expiration) ? expiration : (Time.now + 10).to_i }

  let(:authorization)    { JWT.encode({ **local_user.values, exp: local_expiration.to_i }, Sniphub::SECRET_KEY, "HS256") }
end
