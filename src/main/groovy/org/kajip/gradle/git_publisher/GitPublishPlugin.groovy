package org.kajip.gradle.git_publisher

import org.gradle.api.Plugin
import org.gradle.api.Project

/**
 * 成果物等をGitに登録するプラグイン
 */
class GitPublishPlugin implements Plugin<Project> {

    @Override
    void apply(Project project) {

        project.extensions.create("git_publisher", GitPublisherExtension)

        project.task('gitClone', type: GitCloneTask)
        project.task('gitPublish', type: GitPublishTask)
    }
}
