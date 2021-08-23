class User < ApplicationRecord
  has_secure_password   
  # gem 'bcrypt' (password_digest属性/attr_accessor :password, :password_confirmation /authenticateメソッド)
  # => https://naokirin.hatenablog.com/entry/2019/03/29/032801
end
