require "rails_helper"

describe "タスク管理機能", type: :system do
  before do
    @user_a = create(:user, name: "ユーザーA", email: "a@example.com")
    @label_a = create(:label)
    @label_b = create(:label, name: "ラベルB")
    create(:label, name: "ラベルC")
    @task = create(:task, user: @user_a)
    create(:labelling, task: @task, label: @label_a)
    @next_task = create(:task, name: "次のタスク", deadline: "2020-04-30", status: "完了", priority: "低", user: @user_a)
    create(:labelling, task: @next_task, label: @label_b)
  end

  describe "タスク一覧表示機能" do
    context "ユーザーAがログインしているとき" do
      before do
        visit new_session_path
        fill_in "メールアドレス", with: "a@example.com"
        fill_in "パスワード", with: "password"
        click_button "ログイン"
      end

      it "作成したタスクが表示される" do
        expect(page).to have_content "最初のタスク"
      end

      it "タスクが作成日時の降順で表示される" do
        task_list = all("tbody tr")
        expect(task_list[0]).to have_content "次のタスク"
        expect(task_list[1]).to have_content "最初のタスク"
      end

      it "ソートボタンを押すと終了期限の昇順で表示される", :retry =>4 do
        click_link "▲", href: tasks_path(sort_expired_up: "true")
        task_list = all("tbody tr")
        expect(task_list[0]).to have_content "最初のタスク"
        expect(task_list[1]).to have_content "次のタスク"
      end

      it "ソートボタンを押すと優先順位の降順で表示される", :retry =>4 do
        click_link "▼", href: tasks_path(sort_priority_down: "true")
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

      it "検索フォームでラベル検索できる" do
        select "ラベルA", from: "search_form_label"
        click_button "検索"
        expect(page).to have_no_content "次のタスク"
      end

      it "検索フォームで名称と進捗とラベルで同時に検索できる" do
        fill_in "名称を入力してください", with: "次"
        select "未着手", from: "search_form_status"
        select "ラベルC", from: "search_form_label"
        click_button "検索"
        expect(page).to have_no_content "最初のタスク"
        expect(page).to have_no_content "次のタスク"
      end
    end
  end

  describe "タスク登録機能" do
    context "ユーザーAがログインしているとき" do
      before do
        visit new_session_path
        fill_in "メールアドレス", with: "a@example.com"
        fill_in "パスワード", with: "password"
        click_button "ログイン"
      end

      it "タスクが保存される" do
        click_link "新規登録"
        fill_in "名称", with: "新規タスク"
        fill_in "詳しい説明", with: "新規タスクの説明"
        fill_in "終了期限", with: "04/28/2020"
        select "着手中", from: "進捗"
        select "高", from: "優先順位"
        check "ラベルA"
        click_button "登録する"
        expect(page).to have_content "新規タスク"
        expect(page).to have_content "新規タスクの説明"
        expect(page).to have_content "2020年04月28日"
        expect(page).to have_content "着手中"
        expect(page).to have_content "高"
        expect(page).to have_content "ラベルA"
      end
    end
  end

  describe "タスク詳細表示機能" do
    context "ユーザーAがログインしているとき" do
      before do
        visit new_session_path
        fill_in "メールアドレス", with: "a@example.com"
        fill_in "パスワード", with: "password"
        click_button "ログイン"
      end

      it "該当タスクの詳細画面に遷移する" do
        click_link "最初のタスク", href: task_path(@task)
        expect(page).to have_content "最初のタスク"
      end
    end
  end
end