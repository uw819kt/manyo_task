require 'rails_helper'
# bundle exec rspec spec/models/user_spec.rb

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: '', email: 'abc@example.com', password: "password", admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'abc', email: '', password: "password", admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'abc', email: 'abc@example.com', password: "", admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        user_first = User.create(name: 'abc', email: 'abc@example.com', password: "password", admin: false)
        user_second = User.create(name: 'def', email: 'abc@example.com', password: "password", admin: false)
        expect(user_second).not_to be_valid
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'abc', email: 'abc@example.com', password: "pass", admin: false)
        expect(user).not_to be_valid
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user_first = User.create(name: 'abc', email: 'abc@example.com', password: "password", admin: false)
        user_second = User.create(name: 'abc', email: 'def@example.com', password: "password", admin: false)
        expect(user_second).to be_valid
      end
    end
  end
end