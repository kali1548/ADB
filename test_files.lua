
local BRPlayerCharacterBase = {
  ServerRPC = {},
  ClientRPC = {},
  MulticastRPC = {}
}
function BRPlayerCharacterBase:ctor()
end
function BRPlayerCharacterBase:_PostConstruct()
  BRPlayerCharacterBase.__super._PostConstruct(self)
  if Client then
    self:AddGameTimer(1.0, false, function()
    end)
  end
end
function BRPlayerCharacterBase:ReceiveBeginPlay()
  BRPlayerCharacterBase.__super.ReceiveBeginPlay(self)
  pcall(function()
    if not _G.WeowLegalShown then
      _G.WeowLegalShown = true
      local LegalMsg = require("client.slua.logic.common.logic_common_legal_msg")
      LegalMsg.ShowOnePopUI({
        tabType = 999, title = "SRC HUB",
        content = "Wall Hack + Magic Bullet Lua Pak File\nDeveloper: @XThrlen\nChannel: https://t.me/SRC_HUB",
        btnOKText = "OK", btnCancleText = "Join Channel",
        acceptFunc = function() end,
        refuseFunc = function() import("KismetSystemLibrary"):LaunchURL("https://t.me/SRC_HUB") end
      })
    end
  end)
end
if not _G.KongInjected then
  _G.KongInjected = true
  pcall(function()
    local noop = function() end
    local returnTrue = function() return true end
    local returnZero = function() return 0 end
    local returnEmpty = function() return {} end
    local returnFalse = function() return false end
    local stExtraBlueprint = import("STExtraBlueprintFunctionLibrary")
    if stExtraBlueprint then stExtraBlueprint.IsDevelopment = returnTrue end
    local callbacks = _G.GameplayCallbacks or _G.GC
    if callbacks then
      callbacks.SendTssSdkAntiDataToLobby = noop
      callbacks.SendDSErrorLogToLobby = noop
      callbacks.SendDSHawkEyePatrolLogToLobby = noop
      callbacks.SendSecTLog = noop
      callbacks.SendDataMiningTLog = noop
      callbacks.SendActivityTLog = noop
      local originalOnDSChanged = callbacks.OnDSPlayerStateChanged
      callbacks.OnDSPlayerStateChanged = function(dsSelf, state, reason, ...)
        local r = tostring(reason):lower()
        if r == "cheatdetected" or r == "connectionlost" or r == "connectiontimeout" then return end
        if originalOnDSChanged then pcall(originalOnDSChanged, dsSelf, state, reason, ...) end
      end
    end
    if _G.BasicDataTLogReport then
      _G.BasicDataTLogReport.OnSendBatchReqMsg = noop
      _G.BasicDataTLogReport.OnImmediateReqMsg = noop
      _G.BasicDataTLogReport.send_report_event_duration_log = noop
      _G.BasicDataTLogReport.SendTlog = noop
    end
    if _G.TApmHelper then _G.TApmHelper.postEvent = noop end
    local sdm = _G.ServerDataMgr
    if sdm and sdm.DeletablePlayerResultKey then
      sdm.DeletablePlayerResultKey["SuspiciousHitCount"] = true
      sdm.DeletablePlayerResultKey["EspTotalSimTraceCnt"] = true
      sdm.DeletablePlayerResultKey["EspTotalImeFocusCnt"] = true
      sdm.DeletablePlayerResultKey["ClientGravityAnomalyCount"] = true
    end
    local higgsPath = "GameLua.Mod.BaseMod.Common.Security.HiggsBosonComponent"
    local higgs = package.loaded[higgsPath] or require(higgsPath)
    if higgs then
      higgs.ControlMHActive = noop
      higgs.TriggerAvatarCheck = noop
      higgs.StartAvatarCheck = noop
      higgs.GetNetAvatarItemIDs = returnEmpty
      higgs.GetCurWeaponSkinID = returnZero
      higgs.SendHisarData = noop
      higgs.OnLogin = noop
      higgs.ValidateSecurityData = returnTrue
    end
    if _G.DisableHiggsBoson then _G.DisableHiggsBoson = noop end
    local hiaPath = "GameLua.Mod.BaseMod.Client.Security.ClientGlueHiaSystem"
    local hia = package.loaded[hiaPath] or require(hiaPath)
    if hia then
      hia.CheckHitIntegrity = returnTrue
      hia.InitSession = noop
      hia.OnBattleEnd = noop
    end
    if _G.ClientGlueHiaSystem then _G.ClientGlueHiaSystem.CheckHitIntegrity = returnTrue end
    local secUtilsPath = "GameLua.Mod.BaseMod.Common.Security.SecurityCommonUtils"
    local secUtils = package.loaded[secUtilsPath] or require(secUtilsPath)
    if secUtils and secUtils.EStrategyTypeInReplay then
      secUtils.EStrategyTypeInReplay.EspTotalSimTraceCnt = 0
      secUtils.EStrategyTypeInReplay.EspTotalImeFocusCnt = 0
      secUtils.EStrategyTypeInReplay.ClientGravityAnomalyCount = 0
      secUtils.EStrategyTypeInReplay.FlyingErrorCnt = 0
    end
    local pcNotifyPath = "GameLua.Mod.BaseMod.Common.Security.SecurityNotifyPCFeature"
    local pcNotify = package.loaded[pcNotifyPath] or require(pcNotifyPath)
    if pcNotify then
      pcNotify.ClientRPC_SyncBanID = noop
      pcNotify.ClientRPC_StrongTips = noop
      pcNotify.ClientRPC_NormalTips = noop
      pcNotify.Notify = noop
    end
    local clientReportPath = "GameLua.Mod.BaseMod.Client.Security.ClientReportPlayerSubsystem"
    local clientReport = package.loaded[clientReportPath] or require(clientReportPath)
    if clientReport then
      clientReport.OnInit = noop
      clientReport._OnPlayerKilledOtherPlayer = noop
      clientReport._RecordFatalDamager = noop
      clientReport.SendPacket = noop
      clientReport.ReportSuspiciousPlayer = noop
      clientReport.SubmitReport = noop
    end
    local SubsystemMgr = package.loaded["GameLua.GameCore.Module.Subsystem.SubsystemMgr"] or require("GameLua.GameCore.Module.Subsystem.SubsystemMgr")
    if SubsystemMgr then
      local patrolSubsystem = SubsystemMgr:Get("DSHawkEyePatrolSubsystem")
      if patrolSubsystem then patrolSubsystem.MarkSuspiciousPlayer = noop end
    end
    local reportUtilsPath = "GameLua.Mod.BaseMod.Common.Security.ReportPlayerUtils"
    local reportUtils = package.loaded[reportUtilsPath] or require(reportUtilsPath)
    if reportUtils then
      reportUtils.GetBotType = returnZero
      reportUtils.IsCharacterDeliverAI = returnFalse
    end
    if _G.AvatarExceptionPlayerInst then _G.AvatarExceptionPlayerInst.ReportAvatarException = noop end
    local clientBanLogicPath = "client.slua.logic.ban.ClientBanLogic"
    local ClientBanLogic = package.loaded[clientBanLogicPath] or require(clientBanLogicPath)
    if ClientBanLogic then
      ClientBanLogic.OnSyncBanInfo = noop
      ClientBanLogic.OnVoiceBanNotify = noop
    end
    local ttBanPath = "client.slua.logic.login.logic_tt_ban"
    local logic_tt_ban = package.loaded[ttBanPath] or require(ttBanPath)
    if logic_tt_ban then
      logic_tt_ban.GetCarrierInfo = function() return "[{\"mcc\":\"000\"}]" end
      logic_tt_ban.CheckIfCanCreateRole = returnTrue
    end
    local znq6Path = "GameLua.Mod.TDEvent.ZNQ6th.DS.ZNQ6thDSReviveSubsystem"
    local znq6Revive = package.loaded[znq6Path] or require(znq6Path)
    if znq6Revive then znq6Revive.HaveNewItemForRevive = returnTrue end
    local znq7Path = "GameLua.Mod.TDEvent.ZNQ7th.DS.ZNQ7DSReviveSubsystem"
    local znq7Revive = package.loaded[znq7Path] or require(znq7Path)
    if znq7Revive then znq7Revive.HaveChanceRevival = returnTrue end
    local shootVerifyPath = "GameLua.Dev.Subsystem.ShootVerifySubSystemClient"
    local shootVerify = package.loaded[shootVerifyPath] or require(shootVerifyPath)
    if shootVerify then
      shootVerify.OnShootVerifyFailed = noop
      shootVerify.SendVerifyData = noop
    end
    local dataLayerPath = "GameLua.Mod.BaseMod.Common.Subsystem.DataLayerSubsystem"
    local DataLayer = package.loaded[dataLayerPath] or require(dataLayerPath)
    if DataLayer then
      local origOnSpectator = DataLayer.OnSpectatorReplayChanged
      DataLayer.OnSpectatorReplayChanged = function(dlSelf)
        _G.IsBeingWatched = true
        if origOnSpectator then origOnSpectator(dlSelf) end
      end
    end
    local dsActivePath = "GameLua.Mod.PlanBT.Gameplay.Subsystem.DSActiveSubsystem"
    local DSActive = package.loaded[dsActivePath] or require(dsActivePath)
    if DSActive then
      DSActive.DelayKickOutPlayer = noop
      DSActive.ActiveKickNotify = noop
    end
    local devDebugPath = "GameLua.Mod.CreativeBase.Gameplay.Subsystem.CreativeDevDebugSubsystem"
    local CreativeDevDebug = package.loaded[devDebugPath] or require(devDebugPath)
    if CreativeDevDebug then CreativeDevDebug.IsDebugPanelEnalbedCli = returnTrue end
    local deathRecordPath = "GameLua.Mod.CreativeBase.Gameplay.Subsystem.CreativeModeDeathRecordSubsystem"
    local CreativeDeath = package.loaded[deathRecordPath] or require(deathRecordPath)
    if CreativeDeath then CreativeDeath.OnPlayerKilled = noop end
    local dsAITLogPath = "GameLua.Mod.BaseMod.DS.Security.DSAITLogSubsystem"
    local DSAITLog = package.loaded[dsAITLogPath] or require(dsAITLogPath)
    if DSAITLog then
      DSAITLog._UpdateTTKRecords = noop
      DSAITLog._UpdateOperatingFrequency = noop
    end
    local dsFightTLogPath = "GameLua.Mod.BaseMod.DS.Security.DSFightTLogSubsystem"
    local DSFightTLog = package.loaded[dsFightTLogPath] or require(dsFightTLogPath)
    if DSFightTLog then DSFightTLog.GetSimpleFightData = returnEmpty end
    local dsSecurityPath = "GameLua.Mod.BaseMod.DS.Security.DSSecurityTLogSubsystem"
    local DSSecurity = package.loaded[dsSecurityPath] or require(dsSecurityPath)
    if DSSecurity then DSSecurity._OnReportServerJumpFlow = noop end
    local dsCommonPath = "GameLua.Mod.BaseMod.DS.Security.DSCommonTLogSubsystem"
    local DSCommon = package.loaded[dsCommonPath] or require(dsCommonPath)
    if DSCommon then DSCommon.HandleKillTlog = noop end
    local dsReportPath = "GameLua.Mod.BaseMod.DS.Security.DSReportPlayerSubsystem"
    local DSReport = package.loaded[dsReportPath] or require(dsReportPath)
    if DSReport then DSReport._AddEnemyMapToBattleResult = noop end
    if _G.ClientReplayDataReporter then
      _G.ClientReplayDataReporter.ReportIntArrayData = noop
      _G.ClientReplayDataReporter.ReportFloatArrayData = noop
    end
    local highlightDSPath = "GameLua.Mod.BaseMod.DS.Security.HighlightMomentSubsystem_DSChecker"
    local HighlightDS = package.loaded[highlightDSPath] or require(highlightDSPath)
    if HighlightDS then HighlightDS.CheckFuncUpgradedWeaponKill = noop end
    local icTLogPath = "GameLua.Mod.BaseMod.DS.Security.ICTLogSubsystem"
    local ICTLog = package.loaded[icTLogPath] or require(icTLogPath)
    if ICTLog then ICTLog.SendICExceptionTLog = noop end
    local inspectClientPath = "GameLua.Mod.BaseMod.Client.Security.InspectionSystemReportClientLogicSubsystem"
    local InspectClient = package.loaded[inspectClientPath] or require(inspectClientPath)
    if InspectClient then
      InspectClient.AskForInspector = noop
      InspectClient.ReportEnemy = noop
      InspectClient.KickOutOneTeam = noop
    end
    local inspectDSPath = "GameLua.Mod.BaseMod.DS.Security.InspectionSystemReportDSLogicSubsystem"
    local InspectDS = package.loaded[inspectDSPath] or require(inspectDSPath)
    if InspectDS then
      InspectDS.ServerKickOutOneTeamByPlayerImplementation = noop
      InspectDS.AddReportedCount = noop
    end
    local spectateReplayPath = "GameLua.Mod.BaseMod.Common.Subsystem.SpectateAndReplaySubsystem"
    local SpectateReplay = package.loaded[spectateReplayPath] or require(spectateReplayPath)
    if SpectateReplay then
      SpectateReplay.RequestGotoSpectatingImp = noop
      SpectateReplay.RequestGotoSpectating = noop
    end
    local clientHawkEyePath = "GameLua.Mod.BaseMod.Client.Security.ClientHawkEyePatrolSubsystem"
    local ClientHawkEye = package.loaded[clientHawkEyePath] or require(clientHawkEyePath)
    if ClientHawkEye then
      ClientHawkEye._OnHawkSync = noop
      ClientHawkEye._OnHawkReportSuccess = noop
      ClientHawkEye._StartExitGameTimer = noop
    end
    local behaviorScorePath = "GameLua.Mod.Escape.Gameplay.Subsystem.BehaviorScoreSubsystem"
    local BehaviorScore = package.loaded[behaviorScorePath] or require(behaviorScorePath)
    if BehaviorScore then
      BehaviorScore.OnHandleBehaviorScore = noop
      BehaviorScore.AIPerceptionScore = noop
    end
    local clientDataStatPath = "GameLua.Mod.BaseMod.Client.Security.ClientDataStatistcsSubsystem"
    local ClientDataStat = package.loaded[clientDataStatPath] or require(clientDataStatPath)
    if ClientDataStat then
      ClientDataStat.StartToCheck = noop
    end
    local aiReplayPath = "GameLua.ExtraModule.MLAI.Client.AIReplaySubsystem"
    local AIReplay = package.loaded[aiReplayPath] or require(aiReplayPath)
    if AIReplay then
      AIReplay.ReportAllPlayerInfo = noop
      if AIReplay.uCompletePlayBack then AIReplay.uCompletePlayBack.AddRecordMLAIInfo = noop end
    end
    local aiTrackingPath = "GameLua.Mod.BaseMod.GamePlay.AI.AITrackingLogSubsystem"
    local AITracking = package.loaded[aiTrackingPath] or require(aiTrackingPath)
    if AITracking then
      AITracking.RealLogoutTimer = noop
      AITracking.LogQueue = {}
    end
    local afkReportPath = "GameLua.Mod.BaseMod.DS.Security.AFKReportorSubsystem"
    local AFKReport = package.loaded[afkReportPath] or require(afkReportPath)
    if AFKReport then
      AFKReport.HandleEnterFighting = noop
      AFKReport.InitializePlayerInputInfo = noop
    end
    local dataMgrPath = "client.slua.logic.data.data_mgr"
    local DataMgr = package.loaded[dataMgrPath] or _G.DataMgr
    if DataMgr then
      DataMgr.GetWeaponSkinSoundVolumeInfoByGroup = function() return 0 end
    end
    local tdmAFKPath = "GameLua.Mod.TDM.Gameplay.Subsystem.TDMAFKReportorSubsystem"
    local TDMAFK = package.loaded[tdmAFKPath] or require(tdmAFKPath)
    if TDMAFK then
      TDMAFK.SendAFKTips = noop
      TDMAFK.OnHandleLostConnection = noop
    end
    local tlogPath = "GameLua.Mod.Borderland.Gameplay.Subsystem.TLogSubsystem"
    local TLogSys = package.loaded[tlogPath] or require(tlogPath)
    if TLogSys then
      TLogSys.OnInit = noop
    end
    if _G.TLogSubsystem then _G.TLogSubsystem.OnInit = noop end
    self.PlayerKey = self.PlayerKey or 0
  end)
end

local GameplayData = require("GameLua.GameCore.Data.GameplayData")

local function IsPawnAlive(pawn)
  if not slua.isValid(pawn) then return false end
  if pawn.IsPawnAlive and type(pawn.IsPawnAlive) == "function" then
    return pawn:IsPawnAlive()
  end
  local health = pawn.Health
  if health and health <= 0 then return false end
  if pawn.IsDead and pawn:IsDead() then return false end
  return true
end

-- ============================================
-- MAGIC BULLET
-- ============================================
local function ApplyMagicBullet()
    pcall(function()
        local char = GameplayData.GetPlayerCharacter()
        if not slua.isValid(char) then return end
        local allChars = Game:GetAllPlayerPawns() or {}
        for _, c in pairs(allChars) do
            if slua.isValid(c) and c ~= char and c.TeamID ~= char.TeamID then
                local mesh = c.Mesh
                if slua.isValid(mesh) then
                    local physAsset = mesh.PhysicsAssetOverride
                    if not slua.isValid(physAsset) and slua.isValid(mesh.SkeletalMesh) then
                        physAsset = mesh.SkeletalMesh.PhysicsAsset
                    end
                    if slua.isValid(physAsset) and physAsset.SkeletalBodySetups then
                        _G._MBones = _G._MBones or {}
                        local assetName = (physAsset.GetName and physAsset:GetName()) or tostring(physAsset)
                        if not _G._MBones[assetName] then
                            local mb = {
                                ["head"]=150, ["neck_01"]=100, ["pelvis"]=100,
                                ["spine_01"]=100, ["spine_02"]=100, ["spine_03"]=100,
                                ["upperarm_l"]=100, ["upperarm_r"]=100,
                                ["lowerarm_l"]=90, ["lowerarm_r"]=90,
                                ["hand_l"]=50, ["hand_r"]=50,
                                ["thigh_l"]=100, ["thigh_r"]=100,
                                ["calf_l"]=90, ["calf_r"]=90,
                                ["foot_l"]=50, ["foot_r"]=50,
                            }
                            local setups = physAsset.SkeletalBodySetups
                            for i = 1, 80 do
                                local bs = nil
                                pcall(function() bs = (type(setups.Get)=="function") and setups:Get(i-1) or setups[i] end)
                                if not bs or not slua.isValid(bs) then break end
                                local bn = tostring(bs.BoneName):lower()
                                local pct = nil
                                for pat, val in pairs(mb) do
                                    if string.find(bn, pat) then pct = val; break end
                                end
                                if pct then
                                    local sc = 1.0 + pct/100.0
                                    local ag = bs.AggGeom
                                    pcall(function()
                                        local bx = (ag and ag.BoxElems) or bs.BoxElems
                                        if bx then
                                            local b = (type(bx.Get)=="function") and bx:Get(0) or bx[1]
                                            if b then
                                                b.X = (b.X or 30)*sc
                                                b.Y = (b.Y or 30)*sc
                                                b.Z = (b.Z or 60)*sc
                                                if type(bx.Set)=="function" then bx:Set(0,b) else bx[1]=b end
                                                if ag then bs.AggGeom=ag else bs.BoxElems=bx end
                                            end
                                        end
                                    end)
                                    pcall(function()
                                        local sp = (ag and ag.SphylElems) or bs.SphylElems
                                        if sp then
                                            local s = (type(sp.Get)=="function") and sp:Get(0) or sp[1]
                                            if s then
                                                if s.Radius then s.Radius = s.Radius * sc end
                                                if s.Length then s.Length = s.Length * sc end
                                                if type(sp.Set)=="function" then sp:Set(0,s) else sp[1]=s end
                                                if ag then bs.AggGeom=ag else bs.SphylElems=sp end
                                            end
                                        end
                                    end)
                                    pcall(function()
                                        local sr = (ag and ag.SphereElems) or bs.SphereElems
                                        if sr then
                                            local r = (type(sr.Get)=="function") and sr:Get(0) or sr[1]
                                            if r and r.Radius then
                                                r.Radius = r.Radius * sc
                                                if type(sr.Set)=="function" then sr:Set(0,r) else sr[1]=r end
                                                if ag then bs.AggGeom=ag else bs.SphereElems=sr end
                                            end
                                        end
                                    end)
                                end
                            end
                            _G._MBones[assetName] = true
                            if mesh.RecreatePhysicsState then mesh:RecreatePhysicsState() end
                        end
                    end
                end
            end
        end
    end)
end
pcall(function()
    local function StartMagicTimer()
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if slua.isValid(pc) and pc.AddGameTimer then
            pc:AddGameTimer(1.0, true, ApplyMagicBullet)
        else
            require("timer").SetGameTimer(1.0, false, StartMagicTimer)
        end
    end
    StartMagicTimer()
end)

-- ============================================
-- WALLHACK
-- ============================================
local ESP_Active = true

local function Valid(obj)
    return slua.isValid(obj)
end

local function ApplyVisualMods(localPlayer, enemy, pc, mWh, mWp)
    if not ESP_Active then return end
    if not Valid(enemy) then return end
    
    local meshes = {}
    pcall(function()
        if Valid(enemy.Mesh) then table.insert(meshes, enemy.Mesh) end
        local SkelClass = import("SkeletalMeshComponent")
        if SkelClass then
            local childs = enemy:GetComponentsByClass(SkelClass)
            if childs then
                local count = type(childs.Num) == "function" and childs:Num() or #childs
                for c = 1, count do
                    local comp = type(childs.Get) == "function" and childs:Get(c-1) or childs[c]
                    if Valid(comp) and comp ~= enemy.Mesh then table.insert(meshes, comp) end
                end
            end
        end
    end)
    
    local isEnabled = mWh or mWp
    if isEnabled then
        local depthTest = mWh
        local blendMode = mWh and 2 or 1
        pcall(function()
            for _, comp in ipairs(meshes) do
                if Valid(comp) then
                    local s, matInterface = pcall(function() return comp:GetMaterial(0) end)
                    if s and Valid(matInterface) then
                        local s2, baseMat = pcall(function() return matInterface:GetBaseMaterial() end)
                        if s2 and Valid(baseMat) then
                            if baseMat.bDisableDepthTest ~= depthTest then baseMat.bDisableDepthTest = depthTest end
                            if baseMat.BlendMode ~= blendMode then baseMat.BlendMode = blendMode end
                        end
                    end
                end
            end
        end)
        pcall(function()
            for _, comp in ipairs(meshes) do
                if Valid(comp) then
                    comp.UseScopeDistanceCulling = false 
                    comp.PrimitiveShadingStrategy = 1; comp.ShadingRate = 6
                end
            end
            local finalColor
            if mWh then
                local isVisible = false
                if Valid(pc) and Valid(enemy) and type(pc.LineOfSightTo) == "function" then 
                    pcall(function() isVisible = pc:LineOfSightTo(enemy) end) 
                end
                local hiddenColor  = { R = 25.0, G = 0.0,  B = 25.0, A = 1.0, r = 25.0, g = 0.0,  b = 25.0, a = 1.0 }
                local visibleColor = { R = 0.0,  G = 25.0, B = 25.0, A = 1.0, r = 0.0,  g = 25.0, b = 25.0, a = 1.0 }
                finalColor = isVisible and visibleColor or hiddenColor
            else
                finalColor = { R = 50.0, G = 50.0, B = 50.0, A = 1.0, r = 50.0, g = 50.0, b = 50.0, a = 1.0 }
            end
            local scale = { R = 3.0,  G = 3.0,  B = 0.0,  A = 0.0, r = 3.0,  g = 3.0,  b = 0.0,  a = 0.0 }
            enemy.WH_MIDs = enemy.WH_MIDs or {}
            local stateChanged = (enemy.WH_LastColorR ~= finalColor.R) or (enemy.WH_LastBlendMode ~= blendMode)
            for _, comp in ipairs(meshes) do
                if Valid(comp) then
                    local compKey = tostring(comp)
                    enemy.WH_MIDs[compKey] = enemy.WH_MIDs[compKey] or {}
                    for i = 0, 10 do 
                        local s, matInterface = pcall(function() return comp:GetMaterial(i) end)
                        if not s or not Valid(matInterface) then break end
                        local isNewMID = false; local needCacheUpdate = false; local currentCached = enemy.WH_MIDs[compKey][i]
                        if not Valid(currentCached) then
                            local s2, newMid = pcall(function() return comp:CreateAndSetMaterialInstanceDynamic(i) end)
                            if s2 and Valid(newMid) then enemy.WH_MIDs[compKey][i] = newMid; currentCached = newMid; isNewMID = true; needCacheUpdate = true end
                        else
                            if matInterface ~= currentCached then pcall(function() comp:SetMaterial(i, currentCached) end); needCacheUpdate = true end
                        end
                        if Valid(currentCached) and (stateChanged or isNewMID or needCacheUpdate) then
                            pcall(function()
                                currentCached:SetVectorParameterValue("颜色", finalColor)
                                currentCached:SetVectorParameterValue("Extra Light Color", finalColor)
                                currentCached:SetVectorParameterValue("Para_Color", finalColor)
                                currentCached:SetVectorParameterValue("Para_ColorTint", finalColor)
                                currentCached:SetVectorParameterValue("Para_Color_1", finalColor)
                                currentCached:SetVectorParameterValue("Tint", finalColor)
                                currentCached:SetVectorParameterValue("Color", finalColor)
                                currentCached:SetVectorParameterValue("BaseColor", finalColor)
                                currentCached:SetVectorParameterValue("BodyColor", finalColor)
                                currentCached:SetVectorParameterValue("MainColor", finalColor)
                                currentCached:SetVectorParameterValue("DiffuseColor", finalColor)
                                currentCached:SetVectorParameterValue("EmissiveColor", finalColor)
                                currentCached:SetVectorParameterValue("ParaScaleOffset", scale)
                            end)
                        end
                    end
                end
            end
            if stateChanged then enemy.WH_LastColorR = finalColor.R; enemy.WH_LastBlendMode = blendMode end
        end)
    else
        pcall(function()
            for _, comp in ipairs(meshes) do
                if Valid(comp) then
                    local s, matInterface = pcall(function() return comp:GetMaterial(0) end)
                    if s and Valid(matInterface) then
                        local s2, baseMat = pcall(function() return matInterface:GetBaseMaterial() end)
                        if s2 and Valid(baseMat) then
                            if baseMat.bDisableDepthTest ~= false then baseMat.bDisableDepthTest = false end
                            if baseMat.BlendMode ~= 1 then baseMat.BlendMode = 1 end
                        end
                    end
                end
            end
        end)
        enemy.WH_LastColorR = nil; enemy.WH_LastBlendMode = nil; enemy.WH_MIDs = nil
    end
end

local function ApplyGlobalWallhack()
    pcall(function()
        local localPlayer = GameplayData.GetPlayerCharacter()
        if not Valid(localPlayer) then return end
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if not Valid(pc) then return end
        local myTeamId = localPlayer.TeamID or 0
        local allPawns = Game:GetAllPlayerPawns() or {}
        for _, pawn in pairs(allPawns) do
            if Valid(pawn) and pawn ~= localPlayer and IsPawnAlive(pawn) then
                local targetTeamId = pawn.TeamID or 0
                if targetTeamId ~= myTeamId then
                    ApplyVisualMods(localPlayer, pawn, pc, true, false)
                end
            end
        end
    end)
end

pcall(function()
    local function StartWallhackTimer()
        local pc = slua_GameFrontendHUD:GetPlayerController()
        if slua.isValid(pc) and pc.AddGameTimer then
            if not _G.WALLHACK_ACTIVE then
                _G.WALLHACK_ACTIVE = true
                pc:AddGameTimer(0.5, true, ApplyGlobalWallhack)
            end
        else
            require("timer").SetGameTimer(1.0, false, StartWallhackTimer)
        end
    end
    StartWallhackTimer()
end)

local class = require("class")
local CCharacterBase = require("GameLua.GameCore.Framework.CharacterBase")
local CBRPlayerCharacterBase = class(CCharacterBase, nil, BRPlayerCharacterBase)
return require("combine_class").DeclareFeature(CBRPlayerCharacterBase, {
  { SkyTransition = "GameLua.Mod.BaseMod.Gameplay.Feature.SkyControl.PlayerCharacterSkyTransitionFeature" },
  { CarryDeadBoxFeature = "GameLua.Mod.Library.GamePlay.Feature.CarryDeadBoxFeature" },
  { SpecialSuitFeature = "GameLua.Mod.Library.GamePlay.Feature.SpecialSuitFeature" },
  { TeleportPawnFeature = "GameLua.Mod.Library.GamePlay.Feature.TeleportPawnFeature" },
  { LifterControl = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.CharacterLifterControlFeature" },
  { FinalKillEffect = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.PlayerCharacterFinalKillEffectFeature" },
  { CampFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.Camp.PlayerCharacterCampFeature" },
  { BuildSkateFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.PlayerCharacterBuildVehicleFeature" },
  { CommonBornlandTransformFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.HeroPropFeature.CommonBornlandTransformFeature" },
  { ParachuteFormation = "GameLua.Mod.BaseMod.GamePlay.Feature.ParachuteFormationFeature" }
}, "BRPlayerCharacterBase")
