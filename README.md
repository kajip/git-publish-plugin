git-publish-plugin
======================================

成果物をGitレポジトリに配布するためのGradle Plugin

## 概要

成果物をGitレポジトリで管理するためのタスクを定義したGradle Plugin。


## タスク
以下の２つのタスクが定義されている

* gitClone ... 成果物の配布先レポジトリをcloneする。clone済みの場合、pullを実行する
* gitPublish ... GitレポジトリをCommitしリモートにPushする


## 依存関係

* JDK1.8 以上
* Gradle 2.6 以上


## プロパティ

* git_publish.uri (String): GitレポジトリのURL（必須）
* git_publish.directory (File): ローカルのWorkTreeのディレクトリパス（必須）
* git_publish.remote (String): リモート名（デフォルト：origin）
* git_publish.branch (String): ブランチ（デフォルト：master）
* git_publish.commitMessage (String): コミットメッセージ
* git_publish.credentialsProvider (CredentialsProvider): 認証に使うクラスインスタンス（デフォルト：NetRCCredentialsProvider）


## build.gradle 例

以下の設定を行なうと、```gradle clean build gitPublish``` でコンパイルから公開まで実行される

```groovy

// ライブラリのjarをGitで管理しているプライベートレポジトリに登録する例
buildscript {
    dependencies {
        classpath 'org.kajip:git-publish-plugin:0.1.0.2'
    }
}

apply plugin: 'maven'
apply plugin: 'kajip.git-publish'

ext {
    mavenRepositoryDir = "${buildDir}/repo"
}

// JavaDoc, GroovyDocのjarを生成
task javadocJar(type: Jar, dependsOn: [groovydoc]) {
    classifier = 'javadoc'
    from groovydoc.destinationDir
}

// ソースコードのjarを生成
task sourcesJar(type: Jar) {
    classifier = 'sources'
    from sourceSets.main.allSource
}

artifacts {
    archives jar
    archives javadocJar
    archives sourcesJar
}

// maven plugin の設定
uploadArchives {
    repositories.mavenDeployer {
        repository(url: "file:${mavenRepositoryDir}")
    }
}

// git publisher plugin の設定
git_publish {
    uri 'https://github.com/tkajita/private-repository.git'
    directory new File(mavenRepositoryDir)
    commitMessage "add ${project.name} ${project.version}"
}

// 依存関係を調整（clone -> uploadArchives -> publish）
uploadArchives.dependsOn gitClone
gitPublish.dependsOn uploadArchives

```


## 注意事項

コンフリクトが発生した場合、自力で直してから再度コマンドを実行して下さい


## 既知の問題

* GitHub に ssh で clone/push すると認証が上手く動作しないことがある
