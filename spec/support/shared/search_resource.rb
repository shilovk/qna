# frozen_string_literal: true

shared_examples 'Search only in resource' do
  given(:resource) { resources.first }
  given(:scope) { resource.model_name.to_s }
  given(:other_scopes) { scopes - [scope] }

  scenario 'success search only in resource' do
    ThinkingSphinx::Test.run do
      within '.search form' do
        fill_in :search_query, with: resource.send(testing_field)
        select scope, from: :search_scope
        click_on 'Search'
      end

      expect(page).to have_content resource.send(testing_field)
      (resources - [resource]).each do |r|
        expect(page).to_not have_content r.send(testing_field)
      end
    end
  end

  scenario 'unsuccess search in other resources' do
    ThinkingSphinx::Test.run do
      other_scopes.each do |other_scope|
        within '.search form' do
          fill_in :search_query, with: resource.send(testing_field)
          select other_scope, from: :search_scope
          click_on 'Search'
        end

        expect(page).to_not have_content resource.send(testing_field)
      end
    end
  end
end
