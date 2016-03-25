#!/bin/bash
#
# @(#) force pushとdeleteを防ぎたいブランチ名を定義。
#
# 【スクリプト詳細】
# pre-push.shから呼ばれることを想定。
# ブランチの増減がしやすいように、定義ファイルとして切り出し。
#
# git-flowではmasterとdevelopが、全員で共有され、かつ、重要なブランチなので、最低でもこれらは指定しておくこと。
# ちなみに、feature/protected-branchは本スクリプトの検証用のテストブランチで、削除してもよい。
#
#######################################################################################


# 守りたいbranch名を定義（複数定義可能）
readonly PROTECTED_BRANCHES=( master develop feature/protected-branch )
