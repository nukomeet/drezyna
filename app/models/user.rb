class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:regular, :admin]

  after_initialize :set_default_role, :if => :new_record?

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # validates :username, format: { with: /\A\w+\Z/i }, length: { in: 2..12 }, presence: true, uniqueness: true

  def set_default_role
    self.role ||= :regular
  end
end
