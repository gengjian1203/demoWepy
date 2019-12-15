#!/bin/bash
##################################################
# setJsonBoolean
# 修改json 布尔型字段
# $1 文件
# $2 键
# $3 值
##################################################
setJsonBoolean() {
  echo "setJsonBoolean($*)"
  sed -i '' 's/\("'"${2}"'": \).*/\1'"${3}"',/g' ${1}
}

##################################################
# setJsonString
# 修改json 字符串型字段
# $1 文件
# $2 键
# $3 值
##################################################
setJsonString() {
  echo "setJsonString($*)"
  sed -i '' 's/\("'"${2}"'": "\).*/\1'"${3}"'",/g' ${1}
}

##################################################
# uploadPackage
# 将代码打包上传
# $1 开发者工具路径
# $2 当前路径
# $3 小程序标识（是否专属版）
# $4 AppId
# $5 版本号
# $6 版本备注
##################################################
uploadPackage() {
  # 修改小程序标识
  setJsonBoolean ./src/ext.json extEnable ${3}
  cat ./src/ext.json
  sleep 1
  # 代码编译
  npm run build
  sleep 1
  # 修改开发者工具appid
  setJsonString ./dist/project.config.json appid ${4}
  sleep 8
  # 上传代码
  ${1} -u ${5}@${2}/dist --upload-desc ${6} --upload-info-output ${SHELL_FOLDER}/uploadinfo.json
  sleep 1
  echo "===== 上传完毕 ====="
}

##################################################
# 千米小程序本地打码脚本（仅支持Mac）
# macOS: <安装路径>/Contents/MacOS/cli
# Windows: <安装路径>/cli.bat
# https://www.jianshu.com/p/a988ccb34fe7
# https://www.jianshu.com/p/2d9fa3659645
# 示例
# ./autoPackage.sh V0.1.8 1111版本
# ./autoPackage.sh v0.1.8 1111版本
##################################################
# main
# $0 执行文件
# $1 版本号
# $2 版本备注
##################################################

echo "=====千米小程序本地打码脚本====="
#版本号规则
VERSION_RULE="^[Vv].{1,18}$"
# 当前路径：${SHELL_FOLDER}
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
# 微信开发者工具路径
DEVTOOL_PATH_WIN="${WECHAT_DEVTOOL_PATH_CLI}"
DEVTOOL_PATH_MAC="/Applications/wechatwebdevtools.app/Contents/MacOS/cli"
DEVTOOL_PATH=""
# Appid
APPID_SERVICE=wx821aadcd431646f9
APPID_PLATFORM=wx1cac8cd76fcd3044
# 版本号
VERSION_SERVICE="${1}"
VERSION_PLATFORM="${1}"
# 打包信息
VERSION_INFO="info:${2}"

# 获取开发者工具路径
if [[ "${DEVTOOL_PATH_WIN}" != "" && -e ${DEVTOOL_PATH_WIN} ]]; then
  DEVTOOL_PATH=${DEVTOOL_PATH_WIN}
elif [[ "${DEVTOOL_PATH_MAC}" != "" && -e ${DEVTOOL_PATH_MAC} ]]; then
  DEVTOOL_PATH=${DEVTOOL_PATH_MAC}
fi
if [[ "${DEVTOOL_PATH}" != "" ]]; then
  echo "微信开发者工具路径：${DEVTOOL_PATH}"
else
  echo "微信开发者工具未找到，可能路径错误。"
  exit
fi

if [[ ${1} =~ ${VERSION_RULE} ]]; then
  # 打包专属版
  uploadPackage ${DEVTOOL_PATH} ${SHELL_FOLDER} true ${APPID_SERVICE} ${VERSION_SERVICE} ${VERSION_INFO}
  # 打包平台版
  uploadPackage ${DEVTOOL_PATH} ${SHELL_FOLDER} false ${APPID_PLATFORM} ${VERSION_PLATFORM} ${VERSION_INFO}

  echo -e "专属版本号：${VERSION_SERVICE}\n平台版本号：${VERSION_PLATFORM}"
else
  echo "版本号：${1} 非正常版本号，无法上传打码。"
  exit
fi
