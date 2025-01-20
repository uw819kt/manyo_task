require 'rails_helper'
 RSpec.describe 'ラベル管理機能', type: :system do
   describe '登録機能' do
    let!(:user) { FactoryBot.create(:user) }
    before do     # ログイン処理      
      visit new_session_path
      fill_in 'メールアドレス', with: 'abc@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'    
    end
     context 'ラベルを登録した場合' do
       it '登録したラベルが表示される' do
         click_link "ラベルを登録する"
         fill_in '名前', with: 'label_test'
         click_button '登録する'
         expect(page).to have_content 'label_test'
       end
     end
   end
   describe '一覧表示機能' do
     let!(:user) { FactoryBot.create(:user) }
     before do     # ログイン処理      
       visit new_session_path
       fill_in 'メールアドレス', with: 'abc@example.com'
       fill_in 'パスワード', with: 'password'
       click_button 'ログイン'    
     end
     context '一覧画面に遷移した場合' do
       it '登録済みのラベル一覧が表示される' do
         click_link "ラベルを登録する"
         fill_in '名前', with: 'label_test'
         click_button '登録する'
         click_link "ラベル一覧"
         expect(page).to have_content 'label_test'
       end
     end
   end
 end