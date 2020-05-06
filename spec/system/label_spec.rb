require "rails_helper"

describe "ラベル管理機能", type: :system do
  describe "ラベル登録機能" do
    context "管理ユーザーでログインしているとき" do
      before do
        create(:user, name: "管理ユーザー", email: "admin@example.com", admin: true)
        @label = create(:label, name: "最初のラベル")
        visit new_session_path
        fill_in "メールアドレス", with: "admin@example.com"
        fill_in "パスワード", with: "password"
        click_button "ログイン"
        click_link "ラベル管理"
      end

      it "管理者権限を持つユーザーはラベル管理画面に遷移できる" do
        expect(page).to have_content "ラベル一覧"
      end

      it "管理画面からラベルを登録できる" do
        click_link "新規登録"
        fill_in "ラベル名", with: "テストラベル"
        click_button "登録する"
        expect(page).to have_selector ".alert-success", text: "「テストラベル」を登録しました。"
      end

      it "管理画面からラベルを編集できる" do
        click_link "編集", href: edit_admin_label_path(@label)
        fill_in "ラベル名", with: "編集後ラベル"
        click_button "更新する"
        expect(page).to have_content "編集後ラベル"
      end

      it "管理画面からラベルを削除できる" do
        page.accept_confirm do
          click_link "削除", href: admin_label_path(@label)
        end
        expect(page).to have_selector ".alert-success", text: "「最初のラベル」を削除しました。"
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

      it "管理者権限を持たないユーザーはラベル管理画面に遷移できない" do
        visit admin_labels_path
        expect(current_path).to eq tasks_path
      end
    end

    context "ログインしていないとき" do
      it "ラベル管理機能を利用できない" do
        visit admin_labels_path
        expect(current_path).to eq new_session_path
      end
    end
  end
end