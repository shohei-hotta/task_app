require "rails_helper"

describe "タスク管理機能", type: :system do
  describe "タスク一覧表示機能" do
    context "タスクを作成したとき" do
      before do
        FactoryBot.create(:task, name: "最初のタスク")
        visit tasks_path
      end

      it "作成したタスクが表示される" do
        expect(page).to have_content "最初のタスク"
      end
    end
  end

  describe "タスク登録機能" do
    context "必要項目を入力して、createボタンを押したとき" do
      before do
        visit new_task_path
        fill_in "名称", with: "新規タスク"
        fill_in "詳しい説明", with: "新規タスクの内容"
        click_button "登録する"
      end

      it "タスクの名称が保存される" do
        expect(page).to have_content "新規タスク"
      end
      it "タスクの内容が保存される" do
        expect(page).to have_content "新規タスクの内容"
      end
    end
  end

  describe "タスク詳細表示機能" do
    context "任意のタスクの詳細リンクを押したとき" do
      before do
        task = FactoryBot.create(:task, name: "最初のタスク")
        visit tasks_path
        click_link "詳細", href: task_path(task)
      end

      it "該当タスクの詳細画面に遷移する" do
        expect(page).to have_content "最初のタスク"
      end
    end
  end
end