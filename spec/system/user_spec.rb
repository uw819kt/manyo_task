require 'rails_helper' 
# chromedriverとgoogle-chrome（headless）をインストール
# bundle exec rspec spec/system/user_spec.rbコマンドでテストを実行
# let(:メソッド名) { FactoryBot.create(:モデル名) }

RSpec.describe 'ユーザ管理機能', type: :system do
  describe '登録機能' do
    let!(:user) { FactoryBot.create(:user) }
    context 'ユーザを登録した場合' do # ok
      it 'タスク一覧画面に遷移する' do
        visit new_user_path
        fill_in '名前', with: 'bbb' # fill_in""with:""でフィールド入力
        fill_in 'メールアドレス', with: 'bbb@example.com'
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
      let!(:third_user) { FactoryBot.create(:third_user) }
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: 'ghi@example.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end
      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do # ok
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
    let!(:second_user) { FactoryBot.create(:second_user) }
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'def@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
    end
    context '管理者がログインした場合' do
      it 'ユーザ一覧画面にアクセスできる' do #ok
        click_link "ユーザ一覧"
        expect(page).to have_text 'ユーザ一覧ページ'
      end
      it '管理者を登録できる' do #ok
        click_link "ユーザを登録する"
        sleep 0.5
        fill_in '名前', with: 'aaa'
        fill_in 'メールアドレス', with: 'aaa@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        check '管理者権限'
        click_button '登録する'
        expect(page).to have_text 'ユーザを登録しました'
        expect(page).to have_text 'aaa'
      end
      it 'ユーザ詳細画面にアクセスできる' do #ok
        click_link "ユーザ一覧"
        click_link "詳細"
        expect(page).to have_text 'ユーザ詳細ページ'
      end
      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do #ok
        click_link "ユーザ一覧"
        click_link "編集"
        sleep 0.5
        fill_in '名前', with: 'aaa'
        fill_in 'メールアドレス', with: 'aaa@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        check '管理者権限'
        click_button '更新する'
        expect(page).to have_text 'ユーザを更新しました'
        expect(page).to have_text 'aaa'
      end
      it 'ユーザを削除できる' do #ok
        click_link "ユーザを登録する" # 削除用データ作成
        sleep 0.5
        fill_in '名前', with: 'aaa'
        fill_in 'メールアドレス', with: 'aaa@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        check '管理者権限' # adminを二人に
        click_button '登録する'

        click_link "ユーザ一覧"
        first('a', text: '削除').click 
        # firstはページ内で指定された条件に一致する最初の要素を返すCapybaraのメソッド,'a'は<a>タグ
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_text 'ログインページ'
        expect(page).not_to have_text 'aaa'
      end
    end
    context '一般ユーザがユーザ一覧画面にアクセスした場合' do #OK
      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        click_link 'ログアウト'
        click_link "アカウント登録" # データ作成
        sleep 0.5
        fill_in 'user_name', with: 'aaa'
        fill_in 'user_email', with: 'aaa@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button '登録する'
        
        visit admin_users_path
        expect(page).to have_text '管理者以外アクセスできません'
      end
    end
  end
end