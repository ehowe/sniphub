require "spec_helper"

require_relative "../../../lib/operations/tags/create"

describe Sniphub::Operations::Tags::Create do
  let(:params) { {} }

  shared_examples_for "creating a tag" do
    it "creates a tag" do
      expect do
        operation = described_class.(params)

        expect(operation).to be_success

        expect(operation.result.values).to match(a_hash_including(**params))
      end.to change { Sniphub::Tag.count }.by(1)
    end
  end

  it_behaves_like "creating a tag"

  it_behaves_like "creating a tag" do
    let(:params) { { name: "New tag" } }
  end
end
