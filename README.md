# 说明文档

## 目录结构

```
./
├── README.md
├── report						// 实验报告
├── video						// 展示视频（尚未制作）
└── src							// 源代码
	├── assets					// 前端网页资源
	│   ├── chain.html 			// 注册登录主页
	│   └── index.html 			// 区块链详细信息界面
	├── fisco					// 本地FISCO BCOS链
	├── nodejs-sdk				// FISCO BCOS Node.js SDK
	│   └── packages/cli
	│   	└── cli.js			// CLI工具
	└── server					// 后端服务器
		├── server.js			// 服务器
		├── contracts			// 合约
		│   └── Supplychain.sol	//供应链合约
		└── ...					// SDK相关配置文件...
```



## 运行说明

### 环境要求

- Linux Ubuntu 18.04.1（Windows 尚未测试）
- FISCO-BCOS 2.7.0  
- Node.js >= 8.10.0
- npm >= 5.6.0

### 安装 Node.js SDK

由于FISCO BCOS官方提供的Node.js SDK需要许多第三方包，此处没有将完整的Node.js SDK放置在项目中，需要重新安装；

参考FISCO BCOS官方文档 [Node.js SDK - 快速安装](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/sdk/nodejs_sdk/install.html)；

注意，“拉取源代码”后，需要使用本项目中的 `cli.js` 文件替换FISCO BCOS官方的；这是由于FISCO BCOS官方设定CLI工具仅能在 `nodejs-sdk/packages/cli` 路径下使用，但是本项目后端与链端需要使用该CLI工具，故对FISCO BCOS官方的 `cli.js` 文件做出些许修改；具体做法是删除FISCO BCOS官方的 `cli.js` 文件中对“进程执行路径”和“文件所在路径”的对比检查语句即可；

### 运行服务器

在 `src/server` 目录下，执行

```sh
node server.js
```

有如下输出说明服务器运行成功

```sh
Server running at http://127.0.0.1:8080/
```

### 登录注册

- 登录：http://127.0.0.1/login

- 注册：http://127.0.0.1/register

## 在线展示视频

尚未制作