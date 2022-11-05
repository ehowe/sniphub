require "spec_helper"

require_relative "../../../lib/validators/users/register"

describe Sniphub::Validators::Users::Register do
  let(:username)              { "test@example.com" }
  let(:password)              { "TopSecret!" }
  let(:password_confirmation) { "TopSecret!" }
  let(:first_name)            { "Bob" }
  let(:last_name)             { "Smith" }
  let(:params) do
    {
      "first_name"            => first_name,
      "last_name"             => last_name,
      "password"              => password,
      "password_confirmation" => password_confirmation,
      "username"              => username,
    }
  end

  subject { described_class.validate(params) }

  it { is_expected.to be_success }

  it "includes a confirmation_token in the result" do
    expect(subject.to_h).to have_key(:confirmation_token)
    expect(subject.to_h.fetch(:confirmation_token)).not_to be_nil
    expect(subject.to_h.fetch(:confirmation_token)).not_to be_empty
  end

  shared_examples_for "invalid" do |error|
    it "has the appropriate error message" do
      expect(subject.errors).to include(error)
    end
  end

  context "invalid password" do
    let(:password) { "Topsecret!" }

    it { is_expected.not_to be_success }

    include_examples "invalid", { "password" => "password and confirmation are not equal" }
  end

  context "invalid password confirmation" do
    let(:password_confirmation) { "Topsecret!" }

    it { is_expected.not_to be_success }

    include_examples "invalid", { "password_confirmation" => "password and confirmation are not equal" }
  end

  context "invalid username" do
    let(:username) { "notanemail" }

    it { is_expected.not_to be_success }

    include_examples "invalid", { "username" => "must be an email address" }
  end

  context "missing first name" do
    let(:first_name) { nil }

    it { is_expected.not_to be_success }

    include_examples "invalid", { "first_name" => "is required" }
  end

  context "missing last name" do
    let(:last_name) { nil }

    it { is_expected.not_to be_success }

    include_examples "invalid", { "last_name" => "is required" }
  end
end
