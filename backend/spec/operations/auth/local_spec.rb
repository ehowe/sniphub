require "spec_helper"

require_relative "../../../lib/operations/auth/local"

describe Sniphub::Operations::Auth::Local do
  let(:user)     { create(:user) }
  let(:username) { user.username }
  let(:password) { "password" }
  let(:params) do
    {
      "username" => username,
      "password" => password,
    }
  end

  subject { described_class.(params) }

  it { is_expected.to be_success }

  shared_examples_for "invalid" do |error|
    it "has the appropriate error message" do
      expect(subject.result).to include(error)
    end
  end

  context "invalid password" do
    let(:password) { "invalid" }

    it { is_expected.not_to be_success }

    include_examples "invalid", { "message" => "Invalid username or password" }
  end

  context "invalid username" do
    let(:username) { "invalid" }

    it { is_expected.not_to be_success }

    include_examples "invalid", { "message" => "Invalid username or password" }
  end

  context "user is not confirmed" do
    let(:user) { create(:user, :pending_confirmation) }

    it { is_expected.not_to be_success }

    include_examples "invalid", { "message" => "User is not confirmed" }
  end
end
