package org.kajip.gradle.git_publisher

import org.gradle.api.Project
import org.gradle.testfixtures.ProjectBuilder
import org.junit.Test
import static org.junit.Assert.assertThat
import static org.hamcrest.CoreMatchers.*

/**
 * 成果物等をGitに登録するプラグイン
 */
class GitPublishPluginTest {

    @Test
    public void Pluginがプロジェクトにタスクを追加するテスト() {

        Project project = ProjectBuilder.builder().build()
        project.apply plugin: 'kajip.git-publisher'

        assertThat(project.tasks.gitClone, instanceOf(GitCloneTask))
        assertThat(project.tasks.gitPublish, instanceOf(GitPublishTask))
    }
}
