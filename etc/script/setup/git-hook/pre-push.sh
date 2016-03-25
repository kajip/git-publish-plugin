#!/bin/bash
#
# @(#) git pushの実行直前に呼ばれるgit hook。Gitの重要なリモートブランチへの、force pushとdeleteを防ぐ。
#
# 【スクリプト詳細】
# PROTECTED_BRANCHESに設定したブランチに対して、git push --force等を実行した場合に、エラーになって落ちてくれる。
# これにより、大事なブランチを誤って破壊することを防止する。
#
# 以下のようなコマンドの実行を防ぐ(ここでは、masterブランチを例にしているが、任意のブランチ名を指定可能)
# $ git push -f origin master
# $ git push --force origin master
# $ git push --delete origin master
# $ git push origin :master
#
# ただし、以下のようなケースは本スクリプトでは防げないことに注意（あまりやらないと思われるが。。）
# $ git checkout master
# $ git push --force origin
#
# 【インストール方法】
# 1. chmodコマンドで本スクリプトへの実行権限を付与
# 2. プロジェクトルート直下の".git/hooks/pre-push"から本スクリプトへシンボリックリンクを張る
#
# 【動作条件】
# git 1.8.2以上（pre-push hookはこのバージョン以上でないと使えない）
#
# 【参考URL】
# http://qiita.com/smd8122/items/7067cb34200302b5df12
# https://gist.github.com/pixelhandler/5718585
# http://d.ktmtt.com/-/2013/12/27/git_prevent_force_push_master/
#
#######################################################################################


# スクリプトエラー時に落ちて欲しいので入れておく
set -eu

# 守りたいbranch名の定義スクリプトを読み込み
source "$(dirname $(readlink $0))/define-protected-branches.sh"

# 現在のブランチ名を取得（正確にはブランチ名のフルパスの最後の"/"以降の文字列を取得）
# sedの区切り文字は、Macでファイル名に使用できない":"を採用
# 参考：http://ja.wikipedia.org/wiki/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E5%90%8D
readonly CURRENT_BRANCH=$(git symbolic-ref HEAD | sed -e 's:.*/\(.*\):\1:')

# 実行したpushコマンドを引数含めて取得
readonly PUSH_COMMAND=$(ps -ocommand= -p $PPID)

# 使用禁止引数（この文字列がpushコマンドに含まれるた場合はpushを禁止）
readonly IS_DESTRUCTIVE='\-\-force |\-\-delete |\-f '


# エラーメッセージを出力し、異常終了する関数
error_exit() {
    # エラーメッセージの定義
    local error_message="[Policy] Never push, force push or delete the '$1' branch! (Prevented with pre-push hook.)"

    # エラーメッセージを赤く表示する
    local set_color_red=$(tput setaf 1)
    local reset_color=$(tput sgr0)
    local red_error_message="${set_color_red}${error_message}${reset_color}"

    # エラーメッセージを出力して、異常終了する
    echo ${red_error_message} >&2
    exit 1
}


for i in "${PROTECTED_BRANCHES[@]}"
do

    PROTECTED_BRANCH=${i}

    # 使用禁止引数が含まれていて、かつ、現在のブランチ名が守りたいブランチ名であればエラーにする
    if [[ ${PUSH_COMMAND} =~ ${IS_DESTRUCTIVE} ]] && [ ${CURRENT_BRANCH} = ${PROTECTED_BRANCH} ]; then
        error_exit ${PROTECTED_BRANCH}
    fi

    # 使用禁止引数が含まれていて、かつ、pushコマンドに守りたいブランチ名が含まれていたらエラーにする
    if [[ ${PUSH_COMMAND} =~ ${IS_DESTRUCTIVE} ]] && [[ ${PUSH_COMMAND} =~ ${PROTECTED_BRANCH} ]]; then
        error_exit ${PROTECTED_BRANCH}
    fi

    # リモートブランチ削除の書式
    WILL_REMOVE_PROTECTED_BRANCH=':'${PROTECTED_BRANCH}

    # "git push origin :master"みたいな書き方でもリモートブランチを削除できるので、この場合もエラーにする
    if [[ ${PUSH_COMMAND} =~ ${WILL_REMOVE_PROTECTED_BRANCH} ]]; then
        error_exit ${PROTECTED_BRANCH}
    fi

done

unset -f error_exit

exit 0