require "rails_helper"

describe "ユーザ一機能", type: :system do
  describe "ユーザ一登録機能" do
    it "ユーザ一を登録できる" do
      visit new_user_path
      fill_in "名前", with: "テストユーザー"
      fill_in "メールアドレス", with: "test1@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認用）", with: "password"
      click_button "登録する"
      expect(page).to have_selector ".alert-success", text: "テストユーザー"
    end
  end

  describe "ログイン機能" do
    before do
      @user_a = create(:user)
    end

    it "ログインできる" do
      visit new_session_path
      fill_in "メールアドレス", with: "a@example.com"
      fill_in "パスワード", with: "password"
      click_button "ログイン"
      expect(page).to have_selector ".alert-success", text: "ログインしました。"
    end

    context "ログインしているとき" do
      before do
        visit new_session_path
        fill_in "メールアドレス", with: "a@example.com"
        fill_in "パスワード", with: "password"
        click_button "ログイン"
      end

      it "ユーザー詳細画面に遷移できる" do
        click_link "ユーザー詳細", href: user_path(@user_a)
        expect(page).to have_content "ユーザーA"
      end

      it "他のユーザーの詳細画面に遷移できない" do
        @user_b = create(:user, name: "ユーザーB", email: "b@example.com")
        visit user_path(@user_b)
        expect(current_path).to eq tasks_path
      end

      it "ログアウトできる" do
        click_link "ログアウト"
        expect(page).to have_selector ".alert-success", text: "ログアウトしました。"
      end
    end

    context "ログインしていないとき" do
      it "タスク機能を利用できない" do
        visit tasks_path
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe "ユーザー管理機能" do
    context "管理ユーザーでログインしているとき" do
      before do
        create(:user, name: "管理ユーザー", email: "admin@example.com", admin: true)
        @user_a = create(:user)
        visit new_session_path
        fill_in "メールアドレス", with: "admin@example.com"
        fill_in "パスワード", with: "password"
        click_button "ログイン"
        click_link "ユーザー管理"
      end

      it "管理者権限を持つユーザ一はユーザー管理画面に遷移できる" do
        expect(page).to have_content "ユーザー一覧"
      end

      it "管理画面からユーザーを登録できる" do
        click_link "新規登録"
        fill_in "名前", with: "テストユーザー"
        fill_in "メールアドレス", with: "test@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認用）", with: "password"
        check "管理者権限"
        click_button "登録する"
        expect(page).to have_selector ".alert-success", text: "「テストユーザー」を登録しました。"
      end

      it "管理画面からユーザー詳細画面に遷移できる" do
        click_link "ユーザーA", href: admin_user_path(@user_a)
        expect(page).to have_content "ユーザーA"
        expect(page).to have_content "a@example.com"
        expect(page).to have_content "ユーザーAが登録しているタスク"
      end

      it "管理画面からユーザーを編集できる" do
        click_link "編集", href: edit_admin_user_path(@user_a)
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認用）", with: "password"
        check "管理者権限"
        click_button "更新する"
        user_list = all("tbody tr")
        expect(user_list[1]).to have_content "あり"
      end

      it "管理画面からユーザーを削除できる" do
        page.accept_confirm do
          click_link "削除", href: admin_user_path(@user_a)
        end
        expect(page).to have_selector ".alert-success", text: "「ユーザーA」を削除しました。"
      end
    end

    context "一般ユーザーでログインしているとき" do
      before do
        create(:user)
        visit new_session_path
        fill_in "メールアドレス", with: "a@example.com"
        fill_in "パスワード", with: "password"
        click_button "ログイン"
      end

      it "管理者権限を持たないユーザーはユーザー管理画面に遷移できない" do
        visit admin_users_path
        expect(current_path).to eq tasks_path
      end
    end
  end
end