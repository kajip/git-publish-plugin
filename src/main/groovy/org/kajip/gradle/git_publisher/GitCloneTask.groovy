package org.kajip.gradle.git_publisher

import org.eclipse.jgit.api.Git
import org.eclipse.jgit.api.ListBranchCommand.ListMode
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction

class GitCloneTask extends DefaultTask {

    @TaskAction
    def invoke() {

        GitPublisherExtension config = getProject().git_publisher


        // ワークツリーの取得
        Git git = openWorkTree(config)

        // ブランチリストの取得
        // git branch
        RefList refs = new RefList(git.branchList().setListMode(ListMode.ALL).call())

        if (refs.hasNotLocalBranch(config.branch)) {
            // git branch <<branch>>
            git.branchCreate()
                    .setName(config.branch)
                    .call()
        }

        // git checkout <<branch>>
        git.checkout()
                .setName(config.branch)
                .call()


        if (refs.hasRemoteBranch(config.remote, config.branch) ) {
            // git pull <<remote>> <<branch>>
            git.pull()
                    .setCredentialsProvider(config.credentialsProvider)
                    .setRemote(config.remote)
                    .setRemoteBranchName(config.branch)
                    .call()
        }
    }

    private Git openWorkTree(GitPublisherExtension config) {
        if (!config.directory.isDirectory()) {

            // git clone <<uri>> <<directory>>
            return Git.cloneRepository()
                    .setCredentialsProvider(config.credentialsProvider)
                    .setURI(config.uri)
                    .setDirectory(config.directory)
                    .call()
        } else {

            return Git.open(config.directory)
        }
    }
}
