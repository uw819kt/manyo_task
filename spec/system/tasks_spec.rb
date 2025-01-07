require 'rails_helper' 
# chromedriverとgoogle-chrome（headless）をインストール
# bundle exec rspec spec/system/tasks_spec.rbコマンドでテストを実行

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    let!(:task) { FactoryBot.create(:task, title: 'task_title') }
    # let(:メソッド名) { FactoryBot.create(:モデル名) }

    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in 'タイトル', with: '書類作成' # fill_in""with:""でフィールド入力
        fill_in '内容', with: '書類作成の内容'
        click_button "登録する"
        expect(page).to have_text '書類作成'
      end
    end
  end

  describe '一覧表示機能' do
    let!(:task) { FactoryBot.create(:task, title: 'task_title') }
    # 変数のように扱うことができる、複数テストでデータ共有可、let!は使用時に読み込まれる
    let!(:second_task) { FactoryBot.create(:task, title: 'task_title') }
    let!(:third_task) { FactoryBot.create(:task, title: 'task_title') }

    before do
    # contextが実行されるタイミングでbefore内のコードが実行
      visit tasks_path
    end

  describe 'ソート機能' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', deadline_on: Date.new(2022, 2, 18), priority: '中') }
    let!(:second_task) { FactoryBot.create(:second_task, title: "second_task_title", deadline_on: Date.new(2022, 2, 17), priority: '高') }
    let!(:third_task) { FactoryBot.create(:third_task, title: "third_task_title", deadline_on: Date.new(2022, 2, 16), priority: '低') }
    context '「終了期限」というリンクをクリックした場合' do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do
        # allメソッドを使って複数のテストデータの並び順を確認する
        click_link "終了期限"
        expect(Task.all.order(deadline_on: :asc).first.deadline_on).to eq Date.new(2022, 2, 16)
      end
    end
      context '「優先度」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          click_link "優先度"
          expect(Task.all.order(priority: :desc).first.priority).to eq "高"
        end
      end
    end

  describe '検索機能' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', deadline_on: Date.new(2022, 2, 18), priority: '中') }
    let!(:second_task) { FactoryBot.create(:second_task, title: "second_task_title", deadline_on: Date.new(2022, 2, 17), priority: '高') }
    let!(:third_task) { FactoryBot.create(:third_task, title: "third_task_title", deadline_on: Date.new(2022, 2, 16), priority: '低') }
    context 'タイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        fill_in 'タイトル', with: 'first'
        click_button "検索"
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
      end
    end
    context 'ステータスで検索した場合' do
      it "検索したステータスに一致するタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        select '未着手', from: 'search_status'
        click_button "検索"
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
      end
    end
    context 'タイトルとステータスで検索した場合' do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        fill_in 'タイトル', with: 'first'
        select '未着手', from: 'search_status'
        click_button "検索"
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
      end
    end
  end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        expect(page).to have_content 'task'
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        expect(page).to have_content 'task'
      end
    end
  end

  describe '詳細表示機能' do
    let!(:task) { FactoryBot.create(:task, title: 'task') }

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
