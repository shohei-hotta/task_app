require "rails_helper"

describe "タスク管理機能", type: :system do
  before do
    @task = FactoryBot.create(:task)
  end

  describe "タスク一覧表示機能" do
    context "タスクを作成したとき" do
      before do
        visit tasks_path
      end

      it "作成したタスクが表示される" do
        expect(page).to have_content "最初のタスク"
      end
    end

    context "複数のタスクを作成したとき" do
      before do
        FactoryBot.create(:task, name: "次のタスク", deadline: "2020-04-30", status: "完了", priority: "低")
        visit tasks_path
      end

      it "タスクが作成日時の降順で表示される" do
        task_list = all("tbody tr")
        expect(task_list[0]).to have_content "次のタスク"
        expect(task_list[1]).to have_content "最初のタスク"
      end

      it "ソートボタンを押すと終了期限の昇順で表示される", :retry =>4 do
        click_link "終了期限でソートする", href: tasks_path(sort_expired: "true")
        task_list = all("tbody tr")
        expect(task_list[0]).to have_content "最初のタスク"
        expect(task_list[1]).to have_content "次のタスク"
      end

      it "ソートボタンを押すと優先順位の降順で表示される", :retry =>4 do
        click_link "優先順位でソートする", href: tasks_path(sort_priority: "true")
        task_list = all("tbody tr")
        expect(task_list[0]).to have_content "最初のタスク"
        expect(task_list[1]).to have_content "次のタスク"
      end

      it "検索フォームで名称検索できる" do
        fill_in "名称を入力してください", with: "最初"
        click_button "検索"
        expect(page).to have_no_content "次のタスク"
      end

      it "検索フォームで進捗検索できる" do
        select "完了", from: "search_form_status"
        click_button "検索"
        expect(page).to have_no_content "最初のタスク"
      end

      it "検索フォームで名称と進捗の両方で検索できる" do
        fill_in "名称を入力してください", with: "次"
        select "未着手", from: "search_form_status"
        click_button "検索"
        expect(page).to have_no_content "最初のタスク"
        expect(page).to have_no_content "次のタスク"
      end
    end
  end

  describe "タスク登録機能" do
    context "必要項目を入力して、createボタンを押したとき" do
      before do
        visit new_task_path
        fill_in "名称", with: "新規タスク"
        fill_in "詳しい説明", with: "新規タスクの説明"
        fill_in "終了期限", with: "04/28/2020"
        select "着手中", from: "進捗"
        select "高", from: "優先順位"
        click_button "登録する"
      end

      it "タスクが保存される" do
        expect(page).to have_content "新規タスク"
        expect(page).to have_content "新規タスクの説明"
        expect(page).to have_content "2020年04月28日"
        expect(page).to have_content "着手中"
        expect(page).to have_content "高"
      end
    end
  end

  describe "タスク詳細表示機能" do
    context "任意のタスクの詳細リンクを押したとき" do
      before do
        visit tasks_path
        click_link "最初のタスク", href: task_path(@task)
      end

      it "該当タスクの詳細画面に遷移する" do
        expect(page).to have_content "最初のタスク"
      end
    end
  end
end