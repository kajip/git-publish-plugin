package org.kajip.gradle.git_publisher

import org.eclipse.jgit.transport.CredentialsProvider
import org.eclipse.jgit.transport.NetRCCredentialsProvider

/**
 * 成果物等をGitに登録するプラグイン
 */
class GitPublisherExtension {

    CredentialsProvider credentialsProvider = new NetRCCredentialsProvider()

    File directory

    String uri

    String remote = 'origin'

    String branch = 'master'

    String commitMessage
}
