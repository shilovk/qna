# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchService do
  context 'search for all resources' do
    let(:search) { Search.new(query: 'body', scope: 'All') }

    it 'all resources' do
      expect(ThinkingSphinx).to receive(:search).with('body')

      SearchService.new(search).call
    end
  end

  context 'search for resource' do
    %w[Question Answer Comment User].each do |resource|
      it "#{resource} model" do
        search = Search.new(query: 'body', scope: resource)
        expect(resource.constantize).to receive(:search).with('body')

        SearchService.new(search).call
      end
    end
  end
end
