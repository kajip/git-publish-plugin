#!/bin/bash
#
# @(#) git mergeの実行直後に呼ばれるgit hook。git hookスクリプトを自動で最新に保つ。
#
# 【スクリプト詳細】
# git mergeを実行するたびに、git hookのセットアップスクリプトが更新されていないかチェックし
# 更新されていれば、改めてgit hookのセットアップスクリプトを実行する。
# これにより、開発者が特に意識しなくても、常に最新のgit hookスクリプトを実行できるようにする。
#
# なお、git hookのセットアップスクリプトについては別で用意している前提としている。
#
# 【インストール方法】
# 1. chmodコマンドで本スクリプトへの実行権限を付与
# 2. プロジェクトルート直下の".git/hooks/post-merge"から本スクリプトへシンボリックリンクを張る
#
# 【参考URL】
# http://yosuke-furukawa.hatenablog.com/entry/2014/03/31/125131
#
#######################################################################################


# スクリプトエラー時に落ちて欲しいので入れておく
set -eu

# git hookのセットアップスクリプトのファイル名
readonly SETUP_GIT_HOOK_FILENAME='setup-git-hook.sh'

# git hookのセットアップスクリプトのフルパス取得
readonly SETUP_GIT_HOOK_FILE="$(dirname $(readlink $0))/${SETUP_GIT_HOOK_FILENAME}"

# プロジェクトルートのフルパス取得
readonly PROJECT_ROOT_DIR=$(git rev-parse --show-toplevel)

# 更新チェック対象のファイルの相対パスを取得
# sedの区切り文字は、Macでファイル名に使用できない":"を採用
# 参考：http://ja.wikipedia.org/wiki/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E5%90%8D
readonly CHECK_UPDATE_FILE=$(echo ${SETUP_GIT_HOOK_FILE} | sed -e "s:${PROJECT_ROOT_DIR}::" | sed -e 's:/::')

# git hookのセットアップスクリプトが更新されているかチェックし、もし更新されていれば、セットアップスクリプトを実行
readonly GIT_DIFF_TREE_RESULT=$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD | grep ${CHECK_UPDATE_FILE})
if [ ${GIT_DIFF_TREE_RESULT}[0] = $0 ]; then
    echo "${CHECK_UPDATE_FILE} is updated!"
    ${SETUP_GIT_HOOK_FILE}
fi

exit 0