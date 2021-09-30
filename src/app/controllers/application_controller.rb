class ApplicationController < ActionController::Base
  include SessionsHelper
  include CategoriesHelper
  include StatsHelper
  include RelationshipsHelper
  include PostsHelper

  # herokuapp.comから独自ドメインに301リダイレクトを行う方法
  # https://pg-happy.jp/rails-heroku-domain-301redirect.html

  # herokuapp.comから独自ドメインへリダイレクト
  before_action :ensure_domain
  FQDN = 'www.kyodokoza.com'

  # redirect correct server from herokuapp domain for SEO
  def ensure_domain
    return unless /\.herokuapp.com/ =~ request.host
    
    # 主にlocalテスト用の対策80と443以外でアクセスされた場合ポート番号をURLに含める 
    port = ":#{request.port}" unless [80, 443].include?(request.port)
    redirect_to "#{request.protocol}#{FQDN}#{port}#{request.path}", status: :moved_permanently
  end

  private
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインをしてください"
        redirect_to login_url
      end
    end

    def check_have_relationship
      if no_relationship
        flash[:danger] = "家族の登録をしてください"
        redirect_to user_path(current_user)
      end
    end

    def get_relationship
      @relationship = current_user.relationship
    end

end
