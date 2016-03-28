package org.kajip.gradle.git_publish

import org.eclipse.jgit.api.Git
import org.eclipse.jgit.transport.RefSpec
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction

class GitPublishTask extends DefaultTask {

    @TaskAction
    def invoke() {

        GitPublishExtension config = getProject().git_publish


        Git git = Git.open(config.directory)

        // git add .
        git.add()
                .addFilepattern(".")
                .call()

        // git commit -a -m 'add <<project name>> <<project version>>'
        git.commit()
                .setAll(true)
                .setAllowEmpty(false)
                .setMessage(config.commitMessage)
                .call()

        // git push origin <<branch>>
        git.push()
                .setCredentialsProvider(config.credentialsProvider)
                .setRemote(config.remote)
                .setRefSpecs([new RefSpec(config.branch)])
                .call()
    }
}