/*
 * Tencent is pleased to support the open source community by making BK-CI 蓝鲸持续集成平台 available.
 *
 * Copyright (C) 2019 THL A29 Limited, a Tencent company.  All rights reserved.
 *
 * BK-CI 蓝鲸持续集成平台 is licensed under the MIT license.
 *
 * A copy of the MIT License is included in this file.
 *
 *
 * Terms of the MIT License:
 * ---------------------------------------------------
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of
 * the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
 * LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
 * NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package com.tencent.devops.environment.service.slave

import com.tencent.devops.common.service.config.CommonConfig
import com.tencent.devops.environment.dao.slave.SlaveGatewayDao
import com.tencent.devops.environment.pojo.slave.SlaveGateway
import com.tencent.devops.environment.service.AgentUrlService
import com.tencent.devops.environment.service.thirdPartyAgent.upgrade.AgentPropsScope
import org.jooq.DSLContext
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import java.util.concurrent.TimeUnit

@Service
class SlaveGatewayService @Autowired constructor(
    private val dslContext: DSLContext,
    private val slaveGatewayDao: SlaveGatewayDao,
    private val commonConfig: CommonConfig,
    private val agentPropsScope: AgentPropsScope,
    private val agentUrlService: AgentUrlService
) {

    private val cache = ArrayList<SlaveGateway>()
    private var lastUpdate: Long = 0

    fun getShowName(gateway: String): String {
        val gatewayList = if (cache.isEmpty()) {
            getGateway()
        } else {
            cache
        }
        gatewayList.forEach {
            if (it.gateway == gateway) {
                return it.showName
            }
        }
        return "深圳"
    }

    fun getFileGateway(zoneName: String?): String? {
        if (agentPropsScope.useDefaultFileGateway()) {
            val defaultFileGateway = agentPropsScope.getDefaultFileGateway()
            if (defaultFileGateway.isNotBlank()) return defaultFileGateway
        }
        return getConfigGateway(zoneName)
    }

    fun getGateway(zoneName: String?): String? {
        if (agentPropsScope.useDefaultGateway()) {
            val defaultGateway = agentPropsScope.getDefaultGateway()
            if (defaultGateway.isNotBlank()) return defaultGateway
        }
        return getConfigGateway(zoneName)
    }

    private fun getConfigGateway(zoneName: String?): String {
        if (zoneName.isNullOrBlank()) {
            return agentUrlService.fixGateway(commonConfig.devopsBuildGateway!!)
        }
        val gateways = getGateway()
        gateways.forEach {
            if (it.zoneName == zoneName) {
                return agentUrlService.fixGateway(it.gateway)
            }
        }
        return agentUrlService.fixGateway(commonConfig.devopsBuildGateway!!)
    }

    fun getGateway(): List<SlaveGateway> {
        if (need2Refresh()) {
            synchronized(this) {
                if (need2Refresh()) {
                    try {
                        logger.info("Refresh the gateway")
                        cache.clear()
                        val records = slaveGatewayDao.list(dslContext)
                        if (records.isNotEmpty()) {
                            records.forEach {
                                cache.add(SlaveGateway(it.name, it.showName, it.gateway))
                            }
                        }
                    } finally {
                        lastUpdate = System.currentTimeMillis()
                    }
                    logger.info("Get the gateway $cache")
                }
            }
        }
        return cache
    }

    private fun need2Refresh() =
        System.currentTimeMillis() - lastUpdate >= TimeUnit.MINUTES.toMillis(1)

    companion object {
        private val logger = LoggerFactory.getLogger(SlaveGatewayService::class.java)
    }
}
