require 'rails_helper'

RSpec.describe "タスク管理機能", type: :model do
  context "バリデーション" do
    it "名称が入力されていなければ無効" do
      task = Task.new(name: nil)
      task.valid?
      expect(task.errors[:name]).to include("を入力してください")
    end

    it "名称が31文字以上であれば無効" do
      task = Task.new(name: "a" * 31)
      task.valid?
      expect(task.errors[:name]).to include("は30文字以内で入力してください")
    end

    it "詳しい説明が入力されていなければ無効" do
      task = Task.new(description: nil)
      task.valid?
      expect(task.errors[:description]).to include("を入力してください")
    end

    it "詳しい説明が201文字以上であれば無効" do
      task = Task.new(description: "a" * 201)
      task.valid?
      expect(task.errors[:description]).to include("は200文字以内で入力してください")
    end

    it "名称と詳しい説明が規定の文字数で入力されていれば有効" do
      task = Task.new(name: "テストタスク", description: "テストタスクの説明")
      expect(task).to be_valid
    end
  end

  context "scope" do
    before do
      Task.create(name: "メインタスク", description: "説明", deadline: "2020-01-01", status: "未着手")
      task = Task.create(name: "サブタスク", description: "説明", deadline: "2020-01-01", status: "完了")
    end

    it "名称検索できる" do
      expect(Task.search_name("メイン").count).to eq 1
    end

    it "進捗検索できる" do
      expect(Task.search_status("未着手").count).to eq 1
    end

    it "名称検索と進捗検索を両立できる" do
      expect(Task.search_name("タスク").search_status("完了").count).to eq 1
    end
  end
end
