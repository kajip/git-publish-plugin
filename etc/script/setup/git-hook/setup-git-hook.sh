#!/bin/bash
#
# @(#) git hookのセットアップスクリプト。
#
# 【スクリプト詳細】
# プロジェクトの.git/hooksディレクトリからgit hookスクリプトへのシンボリックリンクを張る。
# これにより、チーム内でのgit hookスクリプトの共有を実現する。
#
# ちなみに、.git/hooks配下のスクリプトは通常、バージョン管理の対象外であるため、
# git hookの実体ファイルは別に用意し、.git/hooksからシンボリックリンクを張るという実装にした。
#
# 【インストール方法】
# 1. chmodコマンドで本スクリプトへの実行権限を付与
#
# 【参考URL】
# http://kokukuma.blogspot.jp/2012/10/git-git.html
# http://labs.gree.jp/blog/2011/03/2885/
#
#######################################################################################


# スクリプトエラー時に落ちて欲しいので入れておく
set -eu

# プロジェクトルートのフルパス取得
readonly PROJECT_ROOT_DIR=$(git rev-parse --show-toplevel)

# 本スクリプトのディレクトリのフルパス取得
readonly CURRENT_SCRIPT_DIR=$(cd $(dirname $0); pwd)

# プロジェクト毎のgit hookのスクリプトを格納しているディレクトリ
readonly GIT_HOOK_DIR="${PROJECT_ROOT_DIR}/.git/hooks"

# git hookのシンボリックリンクの設定
echo "+ setting git hooks"
ln -sf ${CURRENT_SCRIPT_DIR}/pre-push.sh ${GIT_HOOK_DIR}/pre-push
ln -sf ${CURRENT_SCRIPT_DIR}/post-merge.sh ${GIT_HOOK_DIR}/post-merge

exit 0