require "spec_helper"

require_relative "../../../lib/operations/snippets/create"

describe Sniphub::Operations::Snippets::Create do
  let(:params) { {} }
  let(:user)   { create(:user) }

  shared_examples_for "creating a snippet" do
    it "creates a snippet" do
      expect do
        operation = described_class.(params: params, user: user)

        expect(operation).to be_success

        expect(operation.result.values).to match(a_hash_including(**params))
      end.to change { Sniphub::Snippet.count }.by(1)
    end
  end

  it_behaves_like "creating a snippet"

  it_behaves_like "creating a snippet" do
    let(:params) { { name: "New snippet" } }
  end

  it_behaves_like "creating a snippet" do
    let(:params) { { name: "New snippet", language: "typescript" } }
  end

  it_behaves_like "creating a snippet" do
    let(:params) { { name: "New snippet", language: "typescript", content: "snippet content" } }
  end
end
