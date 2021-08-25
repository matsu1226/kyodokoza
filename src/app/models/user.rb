class User < ApplicationRecord
  attr_accessor :activation_token

  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 10 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i    
  # 【英数字, _, +, -, . を1文字以上】＠【英小文字, 数字, -, . を1文字以上】.【英小文字を1文字以上】
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: 8, maximum: 20 }, allow_nil: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  
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
    digest = send("#{attribute_name}_digest")    # acctivation_digest, 
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def send_activation_email   # user#create
    UserMailer.account_activation(self).deliver_now
  end

  def activate  # account_activation#edit
    update(activated_at: Time.zone.now)
    update(activated: true)
  end

  

  private
    def create_activation_digest
      # self.activation_token = User.new_token
      # # self.activation_digest = User.digest(activation_token)
      # update(:activation_digest, User.digest(activation_token))
      # update(:activated_at, Time.zone.now)
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end

