require "spec_helper"

require_relative "../../../lib/operations/snippets/tag"

describe Sniphub::Operations::Snippets::Tag do
  let(:snippet) { create(:snippet) }
  let(:tag)     { create(:tag) }

  it "adds a tag to the snippet" do
    expect do
      operation = described_class.(snippet, tag_ids: [ tag.id ])

      expect(operation).to be_success

      expect(operation.result.tags).to contain_exactly(tag)
    end.to change { snippet.tags_dataset.count }.by(1)
  end

  it "adds multiple tags" do
    other_tag = create(:tag)

    expect do
      operation = described_class.(snippet, tag_ids: [ tag.id, other_tag.id ])

      expect(operation).to be_success

      expect(operation.result.tags).to contain_exactly(tag, other_tag)
    end.to change { snippet.tags_dataset.count }.by(2)
  end

  it "doesnt explode if no tags are passed" do
    expect do
      operation = described_class.(snippet)

      expect(operation).to be_success

      expect(operation.result.tags).to be_empty
    end.not_to change { snippet.tags_dataset.count }
  end
end
