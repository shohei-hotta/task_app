# README
## アプリのURL
https://nameless-bayou-59958.herokuapp.com/

## DB設計
FK：foreign_key

### tasksテーブル

|column     |type    |
|-----------|--------|
|id         |integer |
|name       |string  |
|description|string  |
|deadline   |datetime|
|priority   |integer |
|status     |string  |
|user_id(FK)|integer |

### usersテーブル

|column         |type   |
|---------------|-------|
|id             |integer|
|name           |string |
|email          |string |
|password_digest|string |
|admin          |boolean|

### groupsテーブル

|column      |type   |
|------------|-------|
|id          |integer|
|task_id(FK) |integer|
|label_id(FK)|integer|

### labelsテーブル

|column|type   |
|------|-------|
|id    |integer|
|name  |string |

## バージョン情報
* ruby 2.6.5  
* rails 5.2.4
* PostgreSQL 9.5.21

## 手動デプロイ手順
1. Herokuにアプリケーションを作成
```
$ heroku create
```
2. アセットプリコンパイルを実行
```
$ rails assets:precompile RAILS_ENV=production
```

3. buildpackを指定
```
$ heroku buildpacks:set heroku/ruby
$ heroku buildpacks:add --index 1 heroku/nodejs
```

4. Herokuにデプロイ
```
$ git add .
$ git commit -m "内容"
$ git push heroku master
```

5. データベースの移行
```
$ heroku run rails db:migrate
```

## 自動デプロイ手順
1. Githubのmasterにコードがマージされる。

2. 自動的にコード内のユニットテストが実行され、全てパスしたらデプロイ実行。