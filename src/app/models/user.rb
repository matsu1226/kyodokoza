class User < ApplicationRecord
  has_one :user_relationship, dependent: :destroy
  has_one :relationship, through: :user_relationship
  has_many :posts, dependent: :destroy
  has_many :incomes, dependent: :destroy

  attr_accessor :activation_token, :reset_token, :invitation_token, :remember_token

  before_save :create_activation_digest
  # before_save => createもupdateも
  # before_create :create_activation_digest

  validates :name,
            presence: true,
            length: { maximum: 10 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  # 【英数字, _, +, -, . を1文字以上】＠【英小文字, 数字, -, . を1文字以上】.【英小文字を1文字以上】
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  validates :password,
            presence: true,
            length: { minimum: 8, maximum: 20 },
            unless: -> { validation_context == :except_password_change }
  validates :password_confirmation,
            presence: true,
            unless: -> { validation_context == :except_password_change }

  has_secure_password
  # gem 'bcrypt' (password_digest属性/attr_accessor :password, :password_confirmation /authenticateメソッド)
  # => https://naokirin.hatenablog.com/entry/2019/03/29/032801

  def self.digest(token)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(token, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
    # A–Z、a–z、0–9、"-"、"_"（64種類）からなる長さ22のランダムな文字列を返す
    # https://docs.ruby-lang.org/ja/latest/method/SecureRandom/s/urlsafe_base64.html
  end

  def authenticated?(attribute_name, token)
    digest = send("#{attribute_name}_digest") # acctivation_digest,
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # user#create
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # account_activation#edit
  def activate
    self.attributes = { activated_at: Time.zone.now, activated: true }
    save(context: :except_password_change)
    # update(activated_at: Time.zone.now)
    # update(activated: true)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update(reset_digest: User.digest(reset_token))
    update(reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def create_invitation_digest
    self.invitation_token = User.new_token
    update(invitation_digest: User.digest(invitation_token))
    update(invitation_made_at: Time.zone.now)
  end

  def no_relationship?
    user_relationship.nil?
  end

  def remember
    self.remember_token = User.new_token
    update(remember_digest: User.digest(remember_token))
  end

  def forget
    update(remember_digest: nil)
  end

  def create_common_user
    password = SecureRandom.urlsafe_base64(10)
    User.create(name: '共通',
                email: "common_#{id}@kyodokoza.com",
                password: password,
                password_confirmation: password)
  end

  def self.guest(name)
    find_or_create_by!(email: "guest_#{name}@example.com") do |g|
      password = SecureRandom.urlsafe_base64(10)
      g.name = "ゲスト_#{name}"
      g.password = password
      g.password_confirmation = password
    end
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
