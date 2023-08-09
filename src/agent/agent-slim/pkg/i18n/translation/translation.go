// Code generated by "translation_generator"; DO NOT EDIT.

package translation

import "github.com/nicksnyder/go-i18n/v2/i18n"

// Translations 保存当前所有的翻译
var Translations map[string][]*i18n.Message = make(map[string][]*i18n.Message)

func init() {
	Translations["en-US"] = []*i18n.Message{
		{
			ID: "BuildProcessErr", Other: "build process err, pid: {{.pid}}, err: {{.err}}."},
		{
			ID: "BuilderProcessWasKilled", Other: "Builder process was killed, it may be killed by the operating system or other programs. You need to self-check and reduce the load and try again, or unzip agent.zip, restore the installation, restart the agent and try again."},
		{
			ID: "CreateStartScriptFailed", Other: "create start script failed: {{.err}}"},
		{
			ID: "CreateTmpDirectoryFailed", Other: "create tmp directory failed: {{.err}}"},
		{
			ID: "ExecutableFileMissing", Other: "\nMissing {{.filename}}, `run install.sh` or `unzip agent.zip` in {{.dir}}."},
		{
			ID: "StartWorkerProcessFailed", Other: "start worker process failed: {{.err}}"},
		{
			ID: "WorkerExit", Other: "worker pid[%d] exit"},
	}
	Translations["zh-CN"] = []*i18n.Message{
		{
			ID: "BuildProcessErr", Other: "构建进程运行错误, 进程号: {{.pid}}, 错误: {{.err}}."},
		{
			ID: "BuilderProcessWasKilled", Other: "业务构建进程异常退出，可能被操作系统或其他程序杀掉，需自查并降低负载后重试，或解压 agent.zip 还原安装后重启agent再重试。"},
		{
			ID: "CreateStartScriptFailed", Other: "准备构建脚本生成失败: {{.err}}"},
		{
			ID: "CreateTmpDirectoryFailed", Other: "创建临时目录失败: {{.err}}"},
		{
			ID: "ExecutableFileMissing", Other: "\n{{.filename}} 执行文件丢失，请到 {{.dir}} 目录下执行 install.sh 或者重新解压 agent.zip 还原安装目录"},
		{
			ID: "StartWorkerProcessFailed", Other: "启动构建进程失败: {{.err}}"},
		{
			ID: "WorkerExit", Other: "构建进程 {{.pid}} 退出"},
	}
}
