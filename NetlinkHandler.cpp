/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define LOG_TAG "Vold"

#include <cutils/log.h>

#include <sysutils/NetlinkEvent.h>
#include "NetlinkHandler.h"
#include "VolumeManager.h"

NetlinkHandler::NetlinkHandler(int listenerSocket) :
                NetlinkListener(listenerSocket) {
}

NetlinkHandler::~NetlinkHandler() {
}

int NetlinkHandler::start() {
    return this->startListener();
}

int NetlinkHandler::stop() {
    return this->stopListener();
}

void NetlinkHandler::onEvent(NetlinkEvent *evt) {
    VolumeManager *vm = VolumeManager::Instance();
    const char *subsys = evt->getSubsystem();

    if (!subsys) {
        SLOGW("No subsystem found in netlink event");
        return;
    }

    if (!strcmp(subsys, "block")) {
        vm->handleBlockEvent(evt);
    }
#if defined(BOARD_USES_HDMI)
#if defined(SAMSUNG_EXYNOS5250) || defined(BOARD_USE_V4L2) || defined(BOARD_USE_V4L2_ION)
    else if (!strcmp(subsys, "platform")) {
        vm->handleHdmiEvent(evt);
    }
#elif defined(SAMSUNG_EXYNOS4x12) || (BOARD_USES_HDMI)
    else if (!strcmp(subsys, "misc")) {
		SLOGD("lt::%s::onEvent::vm->handleHdmiEvent(evt)",__func__);//lt,debug
        vm->handleHdmiEvent(evt);//lt, catch the event
    }
#endif
#endif
}
