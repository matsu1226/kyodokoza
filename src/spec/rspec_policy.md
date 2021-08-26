# rspec基本方針

- 基本
  - 単体テスト=> model spec, mailer spec
  - 統合テスト=> system spec

  - 例外(メール画面のクリックはできない。。。)
    - アカウント有効化、パスワードリセット=> request spec