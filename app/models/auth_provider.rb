class AuthProvider
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :user_uid, type: String
  field :user_name, type: String
  field :user_screen_name, type: String
  field :user_profile_image_url, type: String

  belongs_to :user

  index({ user_uid: 1 }, { name: "user_uid_index" })

  validates_uniqueness_of :user_uid, scope: [:name]

end