require "spec_helper"

require_relative "../../../lib/operations/users/register"

describe Sniphub::Operations::Users::Register do
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

  subject { described_class.(params) }

  it { is_expected.to be_success }

  it "creates a user" do
    expect do
      result = subject.result

      expect(result.first_name).to eq(first_name)
      expect(result.last_name).to eq(last_name)
      expect(result.username).to eq(username)
    end.to change { Sniphub::User.count }.by(1)
  end

  shared_examples_for "invalid" do |error|
    it "does not change the user count" do
      expect { subject }.not_to change { Sniphub::User.count }
    end

    it "has the appropriate error message" do
      expect(subject.result).to include(error)
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
