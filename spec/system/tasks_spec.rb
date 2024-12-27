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
