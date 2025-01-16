require 'rails_helper' 
# chromedriverとgoogle-chrome（headless）をインストール
# bundle exec rspec spec/system/tasks_spec.rbコマンドでテストを実行

RSpec.describe 'タスク管理機能', type: :system do   
  describe '登録機能' do
    let!(:user) { FactoryBot.create(:user) }
    before do     # ログイン処理      
      visit new_session_path
      fill_in 'メールアドレス', with: 'abc@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'    
    end
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do #ok
        task = FactoryBot.create(:task, user: user)
        visit task_path(task)
        expect(page).to have_content 'task1'
        expect(page).to have_content '企画書を作成する'
      end
    end
  end

  describe '一覧表示機能' do
    describe 'ソート機能' do
    let!(:user) { FactoryBot.create(:user) }
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'abc@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
      visit tasks_path
    end
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', deadline_on: Date.new(2022, 2, 18), priority: '中', user: user) }
    let!(:second_task) { FactoryBot.create(:second_task, title: "second_task_title", deadline_on: Date.new(2022, 2, 17), priority: '高', user: user) }
    let!(:third_task) { FactoryBot.create(:third_task, title: "third_task_title", deadline_on: Date.new(2022, 2, 16), priority: '低', user: user) }
    context '「終了期限」というリンクをクリックした場合' do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do
        # allメソッドを使って複数のテストデータの並び順を確認する
        # データベースの中身を順番に並び替えてオブジェクトから取り出す
        click_link "終了期限"
        sleep 1 # page.all('tbody tr')データ生成が間に合ってないため遅らせる
        date = ["2022-02-16", "2022-02-17", "2022-02-18", "2022-02-18"]
        page.all('tbody tr').each_with_index do |tr, idx| 
          # 要素とそのインデックスをブロックに渡して繰り返す
          expect(tr.all("td")[3].text).to eq date[idx] # trは試行回数、idxとdateArrayのインデックス対応
          # trの全ての要素取得、その中の3番目のtd(終了期限)を取得＝dateArrayになるか
        end       
      end
    end
      context '「優先度」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          click_link "優先度"
          sleep 1
          priority = ["高", "中", "中", "低"]
          page.all('tbody tr').each_with_index do |tr, idx|
            expect(tr.all("td")[4].text).to eq priority[idx]
          end
        end
      end
    end

  describe '検索機能' do
    let!(:user) { FactoryBot.create(:user) }
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'abc@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
    end
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', deadline_on: Date.new(2022, 2, 18), priority: '中', user: user) }
    let!(:second_task) { FactoryBot.create(:second_task, title: "second_task_title", deadline_on: Date.new(2022, 2, 17), priority: '高', user: user) }
    let!(:third_task) { FactoryBot.create(:third_task, title: "third_task_title", deadline_on: Date.new(2022, 2, 16), priority: '低', user: user) }
    context 'タイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        fill_in 'タイトル', with: 'first'
        click_button "検索"
        expect(all("tr")[1].text).to have_text 'first_task_title'
        expect(all("tr")[1].text).not_to have_text "second_task_title"
      end
    end
    context 'ステータスで検索した場合' do
      it "検索したステータスに一致するタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        select '未着手', from: 'search_status'
        click_button "検索"
        expect(all("tr")[1].text).to have_text '未着手'
        expect(all("tr")[1].text).not_to have_text "完了"
      end
    end
    context 'タイトルとステータスで検索した場合' do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        fill_in 'タイトル', with: 'first'
        select '未着手', from: 'search_status'
        click_button "検索"
        expect(all("tr")[1].text).to have_text('first_task_title').and have_text('未着手')
        expect(all("tr")[1].text).not_to have_text "second_task_title"
        expect(all("tr")[1].text).not_to have_text "完了"
      end
    end
  end
  
    context '一覧画面に遷移した場合' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: 'abc@example.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        expect(page).to have_content 'task'
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
    context '新たにタスクを作成した場合' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: 'abc@example.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end
      it '新しいタスクが一番上に表示される' do
        expect(page).to have_content 'task'
      end
    end
  end

  describe '詳細表示機能' do
    let!(:user) { FactoryBot.create(:user) }
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'abc@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
    end
    let!(:task) { FactoryBot.create(:task, title: 'task', user: user) }

     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
         visit tasks_path
         expect(page).to have_text task.title
         expect(page).to have_content task.content
         expect(page).to have_content task.created_at.strftime('%Y/%m/%d %H:%M')
        # 時間表示は変更したらそのメソッドまで含ませる
       end
     end
  end
end
