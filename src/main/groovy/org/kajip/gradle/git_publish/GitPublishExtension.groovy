package org.kajip.gradle.git_publish

import org.eclipse.jgit.transport.CredentialsProvider
import org.eclipse.jgit.transport.NetRCCredentialsProvider

/**
 * 成果物等をGitに登録するプラグイン
 */
class GitPublishExtension {

    CredentialsProvider credentialsProvider = new NetRCCredentialsProvider()

    File directory

    String uri

    String remote = 'origin'

    String branch = 'master'

    String commitMessage
}
