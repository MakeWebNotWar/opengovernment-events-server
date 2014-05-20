class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  before_save :check_read_state
  
  field :text, type: String
  field :read_at, type: DateTime
  field :read, type: Boolean, default: false

  belongs_to :user

  private

  def check_read_state
    read = read_at.blank?
  end

end