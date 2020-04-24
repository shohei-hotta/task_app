# README
## DB設計
FK：foreign_key

### tasksテーブル

|column     |type    |
|-----------|--------|
|id         |integer |
|name       |string  |
|description|text    |
|deadline   |datetime|
|priority   |integer |
|status     |string  |

### usersテーブル

|column         |type   |
|---------------|-------|
|id             |integer|
|task_id(FK)    |integer|
|name           |string |
|email          |string |
|password_digest|string |

### groupsテーブル

|column      |type   |
|------------|-------|
|id          |integer|
|task_id(FK) |integer|
|label_id(FK)|integer|

### labelテーブル

|column|type   |
|------|-------|
|id    |integer|
|name  |string |