require 'rails_helper' 
# chromedriverとgoogle-chrome（headless）をインストール
# bundle exec rspec spec/system/user_spec.rbコマンドでテストを実行
# let(:メソッド名) { FactoryBot.create(:モデル名) }

RSpec.describe 'ユーザ管理機能', type: :system do
  describe '登録機能' do
    let(:user) { FactoryBot.create(:user) }
    context 'ユーザを登録した場合' do # ok
      it 'タスク一覧画面に遷移する' do
        visit new_user_path
        fill_in '名前', with: 'abc' # fill_in""with:""でフィールド入力
        fill_in 'メールアドレス', with: 'abc@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        click_button '登録する'
        expect(page).to have_text 'タスク一覧ページ'
      end
    end
    context 'ログインせずにタスク一覧画面に遷移した場合' do # ok
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_text 'ログインしてください'
      end
    end
  end

  describe 'ログイン機能' do
    let!(:user) { FactoryBot.create(:user) }
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'abc@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
    end
    context '登録済みのユーザでログインした場合' do
      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do #ok
        expect(page).to have_text 'ログインしました'
      end
      it '自分の詳細画面にアクセスできる' do #ok
        click_link "アカウント設定"
        expect(page).to have_text 'アカウント詳細ページ'
      end
      let(:third_user) { FactoryBot.create(:user) }
      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do # NG
        visit tasks_path(third_user.tasks.first)
        expect(current_path).to eq tasks_path
        expect(page).to have_text 'タスク一覧ページ'
      end
      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do #ok
        click_link "ログアウト"
        expect(page).to have_text 'ログアウトしました'
      end
    end
  end

  describe '管理者機能' do
    let!(:second_user) { FactoryBot.create(:user) }
    before do
      visit new_session_path
      fill_in 'session_email', with: 'def@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
    end
    context '管理者がログインした場合' do
      it 'ユーザ一覧画面にアクセスできる' do
        click_link "ユーザ一覧"
        expect(page).to have_text 'ユーザ一覧ページ'
      end
      it '管理者を登録できる' do
        click_link "ユーザを登録する"

      end
      it 'ユーザ詳細画面にアクセスできる' do
        click_link "ユーザ一覧"
        click_link "詳細"
        expect(page).to have_text 'ユーザ詳細ページ'
      end
      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        click_link "ユーザ一覧"
        click_link "編集"

      end
      it 'ユーザを削除できる' do
        click_link "ユーザ一覧"
        click_link "削除"

      end
    end
    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
      end
    end
  end
end