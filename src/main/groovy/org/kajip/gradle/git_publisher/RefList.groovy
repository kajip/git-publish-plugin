package org.kajip.gradle.git_publisher

import org.eclipse.jgit.lib.Ref

class RefList {

    List<Ref> refs

    def RefList(List<Ref> refs) {
        this.refs = refs
    }

    boolean hasRemoteBranch(String remote, String branch) {
        return refs.any({ref -> "refs/remotes/${remote}/${branch}" == ref.getName()})
    }

    boolean hasLocalBranch(String branch) {
        return refs.any({ref -> "refs/heads/${branch}" == ref.getName()})
    }

    boolean hasNotLocalBranch(String branch) {
        return !hasLocalBranch(branch)
    }
}
