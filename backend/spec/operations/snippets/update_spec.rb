require "spec_helper"

require_relative "../../../lib/operations/snippets/update"

describe Sniphub::Operations::Snippets::Update do
  let(:snippet) { create(:snippet) }
  let(:params)  { {} }

  shared_examples_for "updating a snippet" do
    it "updates a snippet" do
      operation = described_class.(snippet, params)

      expect(operation).to be_success

      expect(snippet.refresh.values).to match(a_hash_including(**params))
    end
  end

  it_behaves_like "updating a snippet"

  it_behaves_like "updating a snippet" do
    let(:params) { { name: "New name" } }
  end

  it_behaves_like "updating a snippet" do
    let(:params) { { name: "New name", language: "typescript" } }
  end

  it_behaves_like "updating a snippet" do
    let(:params) { { name: "New name", language: "typescript", content: "snippet content" } }
  end
end
