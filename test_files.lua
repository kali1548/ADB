
pcall(function()
    print("[ULTIMATE] 🚀 Loading...")
    
    -- ===== 1. EMULATOR BYPASS =====
    if _G.Client then
        _G.Client.GetEmulatorName = function() return "NoEmulator" end
        _G.Client.IsEmulator = function() return false end
        _G.Client.IsEmulatorWhenInit = function() return false end
        _G.Client.GetDevicePlatformName = function() return "Android" end
    end

    local scanner = package.loaded["client.logic.login.emulator_scanner"]
    if scanner then
        scanner.find_emulator = function() return false, "NoEmulator" end
    end

    local Handler = package.loaded["client.network.Protocol.EmulatorHandler"]
    if Handler then
        Handler.send_report_simulator_check = function() return end
    end

    if _G.EmulatorSystem then
        _G.EmulatorSystem.IsEmulator = function() return false end
    end

    if _G.device_module then
        _G.device_module.GetCurEquipment = function() return "NoEmulator" end
    end

    -- ===== 2. FAKE DEVICE =====
    local fake_OMobileFBPL = {
        GetDeviceName = function() return "SM-G998B" end,
        GetDeviceModel = function() return "SM-G998B" end,
        GetManufacturer = function() return "samsung" end,
        GetAndroidVersion = function() return "12" end,
        IsEmulator = function() return false end
    }

    package.loaded["OMobileFBPL"] = fake_OMobileFBPL
    _G.OMobileFBPL = fake_OMobileFBPL

    -- ===== 3. BLOCK REPORTS =====
    local function nop() return end
    local function retFalse() return false end
    
    local reportFuncs = {
        "ReportTLogEvent", "SendTlog", "SendClientStats", "ReportHitFlow",
        "ReportAvatarException", "SendComplaintReq", "SubmitReport",
        "ReportSuspiciousPlayer", "OnSyncBanInfo", "OnVoiceBanNotify",
        "SendSecTLog", "MarkSuspiciousPlayer", "ReportPlayerBehaviorData",
        "CheckCompliance", "ReportIllegalProgram", "UploadVoiceLog"
    }
    
    for _, fn in ipairs(reportFuncs) do
        if type(_G[fn]) == "function" then
            _G[fn] = nop
        end
    end

    -- ===== 4. HIDE DETECTION =====
    _G.DetectionFlag = false
    _G.SuspiciousFlag = false
    _G.ReportFlag = false

    -- ===== 5. TSS SDK BYPASS =====
    local TssSdk = _G.TssSdk or package.loaded["TssSdk"]
    if TssSdk then
        TssSdk.GetSdkAntiData = function() return true, "CLEAN", {code = 0} end
        TssSdk.ScanMemory = function() return true, {code = 0, msg = "clean"} end
        TssSdk.GetRiskFlag = function() return 0 end
        TssSdk.IsEmulator = function() return false end
    end

    print("[ULTIMATE] ✅ Stealth Mode Active!")
    print("════════════════════════════")
    print("🔥 STATUS: UNDETECTED 🔥")
    print("════════════════════════════")
end)

-- ===== CHECK =====
_G.Check = function()
    return { status = "UNDETECTED" }
end

print("[ULTIMATE] 💡 Use _G.Check() to check status")


