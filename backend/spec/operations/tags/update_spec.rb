require "spec_helper"

require_relative "../../../lib/operations/tags/update"

describe Sniphub::Operations::Tags::Update do
  let(:tag)    { create(:tag) }
  let(:params) { {} }

  shared_examples_for "updating a tag" do
    it "updates a tag" do
      operation = described_class.(tag, params)

      expect(operation).to be_success

      expect(tag.refresh.values).to match(a_hash_including(**params))
    end
  end

  it_behaves_like "updating a tag"

  it_behaves_like "updating a tag" do
    let(:params) { { name: "New tag" } }
  end
end
