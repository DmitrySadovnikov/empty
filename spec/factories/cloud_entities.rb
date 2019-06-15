FactoryBot.define do
  factory :cloud_entity do
    transfer
    cloud_file_id { SecureRandom.uuid }
    cloud_file_url { Faker::Internet.url }

    trait :kind_file do
      file_path { 'spec/fixtures/files/test folder/test.pdf' }
      mime_type { nil }
      parent { create(:cloud_entity, :kind_folder) }
    end

    trait :kind_folder do
      file_path { 'spec/fixtures/files/test folder' }
      mime_type { Google::MIME_TYPE_FOLDER }
    end
  end
end
