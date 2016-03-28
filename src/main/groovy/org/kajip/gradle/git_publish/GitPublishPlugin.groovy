package org.kajip.gradle.git_publish

import org.gradle.api.Plugin
import org.gradle.api.Project

/**
 * 成果物等をGitに登録するプラグイン
 */
class GitPublishPlugin implements Plugin<Project> {

    @Override
    void apply(Project project) {

        project.extensions.create("git_publish", GitPublishExtension)

        project.task('gitClone', type: GitCloneTask)
        project.task('gitPublish', type: GitPublishTask)
    }
}
