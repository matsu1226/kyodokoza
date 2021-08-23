class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 10 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i    
  # 【英数字, _, +, -, . を1文字以上】＠【英小文字, 数字, -, . を1文字以上】.【英小文字を1文字以上】
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: 8, maximum: 20 }, allow_nil: true
  validates :password_confirmation, presence: true


  
  has_secure_password   
  # gem 'bcrypt' (password_digest属性/attr_accessor :password, :password_confirmation /authenticateメソッド)
  # => https://naokirin.hatenablog.com/entry/2019/03/29/032801
end
