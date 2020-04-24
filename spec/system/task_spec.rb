require "rails_helper"

describe "タスク管理機能", type: :system do
  describe "一覧表示機能" do
    before do
      FactoryBot.create(:task, name: "最初のタスク")
    end

    context "タスクを作成したとき" do
      before do
        visit tasks_path
      end

      it "作成したタスクが表示される" do
        expect(page).to have_content "最初のタスク"
      end
    end
  end
end