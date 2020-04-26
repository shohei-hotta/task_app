require 'rails_helper'

RSpec.describe Task, type: :model do
  it "名称が入力されていなければ無効" do
    task = Task.new(description: "詳しい説明")
    expect(task).to be_valid
  end
end
