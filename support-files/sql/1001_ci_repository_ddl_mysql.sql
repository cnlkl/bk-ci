USE devops_ci_repository;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for T_REPOSITORY
-- ----------------------------

CREATE TABLE IF NOT EXISTS `T_REPOSITORY` (
  `REPOSITORY_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `PROJECT_ID` varchar(32) NOT NULL COMMENT '项目ID',
  `USER_ID` varchar(64) NOT NULL DEFAULT '' COMMENT '用户ID',
  `ALIAS_NAME` varchar(255) NOT NULL COMMENT '别名',
  `URL` varchar(255) NOT NULL COMMENT 'url地址',
  `TYPE` varchar(20) NOT NULL COMMENT '类型',
  `REPOSITORY_HASH_ID` varchar(64) DEFAULT NULL COMMENT '哈希ID',
  `CREATED_TIME` timestamp NOT NULL DEFAULT '2019-08-01 00:00:00' COMMENT '创建时间',
  `UPDATED_TIME` timestamp NOT NULL DEFAULT '2019-08-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `IS_DELETED` bit(1) NOT NULL COMMENT '是否删除 0 可用 1删除',
  `ENABLE_PAC` bit(1) NOT NULL DEFAULT false COMMENT '是否开启pac',
  `PAC_SYNC_STATUS` VARCHAR(10) NULL COMMENT 'pac同步状态',
  `PAC_SYNC_CI_DIR_ID` VARCHAR(64) NULL COMMENT 'pac同步的commitId',
  `PAC_SYNC_TIME` timestamp NULL COMMENT 'pac同步时间',
  PRIMARY KEY (`REPOSITORY_ID`),
  KEY `PROJECT_ID` (`PROJECT_ID`),
  KEY `inx_alias_name` (`ALIAS_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='代码库表';

-- ----------------------------
-- Table structure for T_REPOSITORY_CODE_GIT
-- ----------------------------

CREATE TABLE IF NOT EXISTS `T_REPOSITORY_CODE_GIT` (
  `REPOSITORY_ID` bigint(20) NOT NULL COMMENT '仓库ID',
  `PROJECT_NAME` varchar(255) NOT NULL COMMENT '项目名称',
  `USER_NAME` varchar(64) NOT NULL COMMENT '用户名称',
  `CREATED_TIME` timestamp NOT NULL DEFAULT '2019-08-01 00:00:00' COMMENT '创建时间',
  `UPDATED_TIME` timestamp NOT NULL DEFAULT '2019-08-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `CREDENTIAL_ID` varchar(64) NOT NULL COMMENT '凭据 ID',
  `AUTH_TYPE` varchar(8) DEFAULT NULL COMMENT '认证方式',
  `GIT_PROJECT_ID` bigint(20) DEFAULT 0 COMMENT 'GIT项目ID',
  PRIMARY KEY (`REPOSITORY_ID`),
  INDEX IDX_GIT_PROJECT_ID('GIT_PROJECT_ID')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工蜂代码库明细表';

-- ----------------------------
-- Table structure for T_REPOSITORY_CODE_GITLAB
-- ----------------------------

CREATE TABLE IF NOT EXISTS `T_REPOSITORY_CODE_GITLAB` (
  `REPOSITORY_ID` bigint(20) NOT NULL COMMENT '仓库ID',
  `PROJECT_NAME` varchar(255) NOT NULL COMMENT '项目名称',
  `CREDENTIAL_ID` varchar(64) NOT NULL COMMENT '凭据 ID',
  `CREATED_TIME` timestamp NOT NULL DEFAULT '2019-08-01 00:00:00' COMMENT '创建时间',
  `UPDATED_TIME` timestamp NOT NULL DEFAULT '2019-08-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `USER_NAME` varchar(64) NOT NULL COMMENT '用户名称',
  `AUTH_TYPE` varchar(8) DEFAULT NULL COMMENT '凭证类型',
   `GIT_PROJECT_ID` bigint(20) DEFAULT 0 COMMENT 'GIT项目ID',
  PRIMARY KEY (`REPOSITORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='gitlab代码库明细表';

-- ----------------------------
-- Table structure for T_REPOSITORY_CODE_SVN
-- ----------------------------

CREATE TABLE IF NOT EXISTS `T_REPOSITORY_CODE_SVN` (
  `REPOSITORY_ID` bigint(20) NOT NULL COMMENT '仓库ID',
  `REGION` varchar(255) NOT NULL COMMENT '地区',
  `PROJECT_NAME` varchar(255) NOT NULL COMMENT '项目名称',
  `USER_NAME` varchar(64) NOT NULL COMMENT '用户名称',
  `CREATED_TIME` timestamp NOT NULL DEFAULT '2019-08-01 00:00:00' COMMENT '创建时间',
  `UPDATED_TIME` timestamp NOT NULL DEFAULT '2019-08-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `CREDENTIAL_ID` varchar(64) NOT NULL COMMENT '凭据 ID',
  `SVN_TYPE` varchar(32) DEFAULT '' COMMENT '仓库类型',
  PRIMARY KEY (`REPOSITORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='svn代码库明细表';

-- ----------------------------
-- Table structure for T_REPOSITORY_COMMIT
-- ----------------------------

CREATE TABLE IF NOT EXISTS `T_REPOSITORY_COMMIT` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `BUILD_ID` varchar(34) DEFAULT NULL COMMENT '构建ID',
  `PIPELINE_ID` varchar(34) DEFAULT NULL COMMENT '流水线ID',
  `REPO_ID` bigint(20) DEFAULT NULL COMMENT '代码库ID',
  `TYPE` smallint(6) DEFAULT NULL COMMENT '1-svn, 2-git, 3-gitlab',
  `COMMIT` varchar(64) DEFAULT NULL COMMENT '提交',
  `COMMITTER` varchar(32) DEFAULT NULL COMMENT '提交者',
  `COMMIT_TIME` datetime DEFAULT NULL COMMENT '提交时间',
  `COMMENT` longtext COMMENT '评论',
  `ELEMENT_ID` varchar(34) DEFAULT NULL COMMENT '原子ID',
  `REPO_NAME` varchar(128) DEFAULT NULL COMMENT '代码库别名',
  `URL` varchar(255) DEFAULT NULL COMMENT '代码库URL',
  PRIMARY KEY (`ID`),
  KEY `IDX_BUILD_ID_TIME` (`BUILD_ID`, `COMMIT_TIME`),
  KEY `IDX_PIPE_ELEMENT_REPO_TIME` (`PIPELINE_ID`, `ELEMENT_ID`, `REPO_ID`, `COMMIT_TIME`),
  KEY `IDX_PIPE_ELEMENT_NAME_REPO_TIME` (`PIPELINE_ID`, `ELEMENT_ID`, `REPO_NAME`, `COMMIT_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='代码库变更记录';

-- ----------------------------
-- Table structure for T_REPOSITORY_GITHUB
-- ----------------------------

CREATE TABLE IF NOT EXISTS `T_REPOSITORY_GITHUB` (
  `REPOSITORY_ID` bigint(20) NOT NULL COMMENT '仓库ID',
  `CREDENTIAL_ID` varchar(128) DEFAULT NULL COMMENT '凭据 ID',
  `PROJECT_NAME` varchar(255) NOT NULL COMMENT '项目名称',
  `USER_NAME` varchar(64) NOT NULL COMMENT '用户名称',
  `CREATED_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `UPDATED_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `GIT_PROJECT_ID` bigint(20) DEFAULT 0 COMMENT 'GIT项目ID',
  PRIMARY KEY (`REPOSITORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='github代码库明细表';

-- ----------------------------
-- Table structure for T_REPOSITORY_GITHUB_TOKEN
-- ----------------------------

CREATE TABLE IF NOT EXISTS `T_REPOSITORY_GITHUB_TOKEN` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `USER_ID` varchar(64) NOT NULL COMMENT '用户ID',
  `ACCESS_TOKEN` varchar(96) NOT NULL COMMENT '权限Token',
  `TOKEN_TYPE` varchar(64) NOT NULL COMMENT 'token类型',
  `SCOPE` text NOT NULL COMMENT '生效范围',
  `CREATE_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `UPDATE_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `TYPE` varchar(32) DEFAULT 'GITHUB_APP' COMMENT 'GitHub token类型（GITHUB_APP、OAUTH_APP）',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `USER_ID` (`USER_ID`, `TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='github oauth token表';

-- ----------------------------
-- Table structure for T_REPOSITORY_GIT_TOKEN
-- ----------------------------

CREATE TABLE IF NOT EXISTS `T_REPOSITORY_GIT_TOKEN` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `USER_ID` varchar(64) DEFAULT NULL COMMENT '用户ID',
  `ACCESS_TOKEN` varchar(96) DEFAULT NULL COMMENT '权限Token',
  `REFRESH_TOKEN` varchar(96) DEFAULT NULL COMMENT '刷新token',
  `TOKEN_TYPE` varchar(64) DEFAULT NULL COMMENT 'token类型',
  `EXPIRES_IN` bigint(20) DEFAULT NULL COMMENT '过期时间',
  `CREATE_TIME` datetime DEFAULT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'token的创建时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `USER_ID` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工蜂commit checker表';


-- ----------------------------
-- Table structure for T_REPOSITORY_GIT_TOKEN
-- ----------------------------

CREATE TABLE IF NOT EXISTS `T_REPOSITORY_GIT_CHECK` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `PIPELINE_ID` varchar(64) NOT NULL COMMENT '流水线ID',
  `BUILD_NUMBER` int(11) NOT NULL COMMENT '构建编号',
  `REPO_ID` varchar(64) DEFAULT NULL COMMENT '代码库ID',
  `COMMIT_ID` varchar(64) NOT NULL COMMENT '代码提交ID',
  `CREATE_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `UPDATE_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `REPO_NAME` varchar(128) DEFAULT NULL COMMENT '代码库别名',
  `CONTEXT` varchar(255) DEFAULT NULL COMMENT '内容',
  `SOURCE` varchar(64) NOT NULL COMMENT '事件来源',
  PRIMARY KEY (`ID`),
  KEY `PIPELINE_ID_COMMIT_ID` (`PIPELINE_ID`,`COMMIT_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工蜂oauth token表';

-- ----------------------------
-- Table structure for T_REPOSITORY_GIT_TOKEN
-- ----------------------------

CREATE TABLE IF NOT EXISTS `T_REPOSITORY_CODE_P4` (
  `REPOSITORY_ID` BIGINT(20) NOT NULL,
  `PROJECT_NAME` VARCHAR(255) NOT NULL,
  `USER_NAME` VARCHAR(64) NOT NULL,
  `CREDENTIAL_ID` VARCHAR(64) NOT NULL,
  `CREATED_TIME` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPDATED_TIME` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`REPOSITORY_ID`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

create table T_REPOSITORY_TGIT_TOKEN
(
    `ID`            bigint auto_increment comment '主键ID'
        primary key,
    `USER_ID`       varchar(64)                        null comment '用户ID',
    `ACCESS_TOKEN`  varchar(96)                        null comment '权限Token',
    `REFRESH_TOKEN` varchar(96)                        null comment '刷新token',
    `TOKEN_TYPE`    varchar(64)                        null comment 'token类型',
    `EXPIRES_IN`    bigint                             null comment '过期时间',
    `CREATE_TIME`   datetime default CURRENT_TIMESTAMP null comment 'token的创建时间',
    `OAUTH_USER_ID` varchar(64)                        not null comment '账户实际名称',
    constraint `USER_ID`
        unique (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '外网工蜂OAUTH token表';

-- ----------------------------
-- Table structure for T_REPOSITORY_WEBHOOK_REQUEST
-- ----------------------------

CREATE TABLE IF NOT EXISTS `T_REPOSITORY_WEBHOOK_REQUEST`
(
    `REQUEST_ID`      bigint(20) NOT NULL AUTO_INCREMENT COMMENT '请求ID',
    `EXTERNAL_ID`     varchar(255)                       DEFAULT NULL COMMENT '代码库平台ID',
    `REPOSITORY_TYPE` varchar(32)                        DEFAULT NULL COMMENT '触发类型',
    `EVENT_TYPE`      varchar(255)                       DEFAULT NULL COMMENT '事件类型',
    `TRIGGER_USER`    varchar(100)              NOT NULL COMMENT '触发用户',
    `EVENT_MESSAGE`   text                      NOT NULL COMMENT '事件信息',
    `REQUEST_HEADER`  text COMMENT '事件请求头',
    `REQUEST_PARAM`   text COMMENT '事件请求参数',
    `REQUEST_BODY`    text COMMENT '事件请求体',
    `CREATE_TIME`     timestamp                 NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`REQUEST_ID`, `CREATE_TIME`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='代码库WEBHOOK请求表';

CREATE TABLE IF NOT EXISTS `T_REPOSITORY_PAC_SYNC_DETAIL`
(
    `ID`            bigint auto_increment,
    `PROJECT_ID`    varchar(64)  not null comment '项目ID',
    `REPOSITORY_ID` bigint(20)   NOT NULL COMMENT '代码库ID',
    `CI_DIR_ID`     VARCHAR(64)  NOT NULL COMMENT '同步的commitId',
    `FILE_PATH`     varchar(512) NOT NULL DEFAULT '' COMMENT '文件路径',
    `SYNC_STATUS`   VARCHAR(10)  NULL COMMENT 'ci文件同步状态',
    `REASON`         varchar(100)         DEFAULT NULL COMMENT '失败原因',
    `REASON_DETAIL`  text                 DEFAULT NULL COMMENT '原因详情',
    `CREATE_TIME`   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `UPDATE_TIME`  timestamp   default CURRENT_TIMESTAMP null comment '更新时间',
    PRIMARY KEY (`ID`, `CREATE_TIME`),
    UNIQUE KEY `UQE_COMMIT_FILE` (`PROJECT_ID`, `REPOSITORY_ID`, `CI_DIR_ID`, `FILE_PATH`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='pac文件同步详情';

SET FOREIGN_KEY_CHECKS = 1;
