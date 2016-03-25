git-publish-plugin
======================================

成果物をGitレポジトリに配布するためのGradle Plugin

## 概要

成果物をGitレポジトリで管理するためのタスクを定義したGradle Plugin。

２つのタスクが定義されている

    * gitClone ... 成果物の配布先レポジトリをcloneする。clone済みの場合、pullを実行する
    * gitPublish ... GitレポジトリをCommitしリモートにPushする

## 依存関係

* JDK1.8 以上
* Gradle 2.6 以上

## 注意事項

コンフリクトが発生した場合、自力で直してから再度コマンドを実行して下さい

## チートシート

### テスト方法

```bash
$ ./gradlew clean test
```

### バージョンアップ手順

#### リリースブランチ作成


```bash
$ git flow release start <ブランチ名>
```

#### gradleファイル修正

#### リリースノート修正

#### リリースブランチの終了

#### リモートへpush

