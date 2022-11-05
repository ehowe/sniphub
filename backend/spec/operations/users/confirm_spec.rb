require "spec_helper"

require_relative "../../../lib/operations/users/confirm"

describe Sniphub::Operations::Users::Confirm do
  let(:user)  { create(:user, :pending_confirmation) }
  let(:id)    { user.id }
  let(:token) { user.confirmation_token }
  let(:params) do
    {
      "id"    => id,
      "token" => token,
    }
  end

  subject { described_class.(params) }

  it { is_expected.to be_success }

  it "confirms a user" do
    expect { subject }.to change { user.reload.confirmation_token }.to(nil)
  end

  shared_examples_for "invalid" do |error|
    it "has the appropriate error message" do
      expect(subject.result).to include(error)
    end
  end

  context "invalid token" do
    let(:token) { "Topsecret!" }

    it { is_expected.not_to be_success }

    include_examples "invalid", { "confirmation_token" => "invalid" }
  end

  context "invalid id" do
    let(:id) { SecureRandom.uuid }

    it { is_expected.not_to be_success }

    include_examples "invalid", { "confirmation_token" => "invalid" }
  end
end
