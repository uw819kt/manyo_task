require 'rails_helper'
# bundle exec rspec spec/models/task_spec.rb

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '', content: '企画書を作成する。')
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title:'課題提出', content: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        user = User.create!(name: "テストユーザー", email: "user@example.com", password:"password")
        task = Task.create(
          title:'課題提出', 
          content: 'ステップ1まで',
          deadline_on: Date.new(2022, 2, 16),
          priority: "高",
          status: "着手中",
          user_id: user.id
          )
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    # テストデータ作成
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', user: user) }
    let!(:second_task) { FactoryBot.create(:second_task, title: "second_task_title", user: user) }
    let!(:third_task) { FactoryBot.create(:third_task, title: "third_task_title", user: user) }
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
        expect(Task.search_title('first')).not_to include(third_task)
        expect(Task.search_title('first').count).to eq 1
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_status('未着手')).to include(first_task)
        expect(Task.search_status('完了')).not_to include(second_task)
        expect(Task.search_status('着手中')).not_to include(third_task)
        expect(Task.search_status('未着手').count).to eq 1
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_status('未着手')).to include(first_task)
        expect(Task.search_status('完了')).not_to include(second_task)
        expect(Task.search_title('first')).not_to include(second_task)
        expect(Task.search_status('着手中')).not_to include(third_task)
        expect(Task.search_title('first')).not_to include(third_task)
        expect(Task.search_title('first').count).to eq 1
        expect(Task.search_status('未着手').count).to eq 1
      end
    end
  end
end