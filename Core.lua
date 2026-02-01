-- 애드온의 전역 테이블이 없으면 생성 (다른 파일과 공유되는 네임스페이스)
MyCoolAddon = MyCoolAddon or {}
local L = MyCoolAddon.L -- Locales.lua에서 만든 현지화 테이블 가져오기

-- 설정값의 기본 구조
local defaults = {
    firstTimeUser = true,
    framePosition = { "CENTER", "UIParent", "CENTER", 0, 0 },
}

-- 애드온이 로드될 때 실행될 메인 함수
function MyCoolAddon:OnLoad()
    -- SavedVariables로 지정한 MyCoolAddonDB가 없으면 기본값으로 생성
    MyCoolAddonDB = MyCoolAddonDB or defaults

    -- 현지화된 환영 메시지를 채팅창에 출력
    print(L["WELCOME_MESSAGE"])

    -- 버튼 텍스트 설정
    MyCoolAddonFrameButton:SetText(L["BUTTON_TEXT"])
end

-- 슬래시 명령어 처리 함수
function MyCoolAddon.SlashCommandHandler(msg)
    local command = msg:lower() -- 입력된 메시지를 소문자로 변경

    if command == "show" or command == "" then
        -- /mca show 또는 /mca 라고 입력하면 프레임을 보여주거나 숨김 (토글)
        MyCoolAddonFrame:SetShown(not MyCoolAddonFrame:IsShown())
    elseif command == "reset" then
        -- /mca reset 입력 시 위치 초기화
        MyCoolAddonFrame:ClearAllPoints()
        MyCoolAddonFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
        print("Frame position has been reset.")
    else
        print("Unknown command: " .. command)
    end
end

-- XML에서 정의한 버튼의 OnClick 함수
function MyCoolAddon.MyCoolAddonFrameButton_OnClick(self)
    print(L["BUTTON_CLICK_MESSAGE"])
    -- 여기에 버튼 클릭 시 수행할 로직을 추가
end


-- ============================================================================
-- 이벤트 핸들링
-- ============================================================================
-- 애드온 로딩 이벤트를 처리할 프레임 생성
local eventFrame = CreateFrame("Frame", "MyCoolAddonEventFrame")
eventFrame:RegisterEvent("ADDON_LOADED")

-- 이벤트가 발생했을 때 실행될 스크립트
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    -- 로드된 애드온이 "MyCoolAddon"일 때만 OnLoad 함수를 실행
    if event == "ADDON_LOADED" and addonName == "MyCoolAddon" then
        MyCoolAddon:OnLoad()
    end
end)