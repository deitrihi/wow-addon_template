안녕하세요! 월드 오브 워크래프트(WoW) 애드온 개발을 시작하시는군요. 최신 버전(현재 용군단, Dragonflight)에 맞춰 바로 사용할 수 있는 기본 템플릿을 만들어 드리겠습니다.

이 템플릿은 애드온의 기본 구조, 설정 저장, UI 프레임 생성, 한글/영문 현지화, 슬래시(/) 명령어 등록 등 필수적인 기능들을 모두 포함하고 있습니다.

### 📂 애드온 폴더 구조

먼저, WoW 설치 폴더 내의 `_retail_/Interface/AddOns/` 경로에 `MyCoolAddon`이라는 폴더를 만드세요. 그리고 그 안에 다음 4개의 파일을 생성합니다.

```
MyCoolAddon/
├── MyCoolAddon.toc
├── Locales.lua
├── Frames.xml
└── Core.lua
```

---

### 1. `MyCoolAddon.toc` - 애드온 정보 파일

이 파일은 WoW 클라이언트가 애드온을 인식하고 로드하기 위한 가장 중요한 파일입니다. 애드온의 정보와 로드할 파일 목록을 정의합니다.

```toc
## Interface: 100207
## Title: MyCoolAddon
## Notes: A basic template for developing a new addon.
## Author: YourName
## Version: 1.0.0
## SavedVariables: MyCoolAddonDB

## Title-koKR: |cffFFFF00나의 멋진 애드온|r
## Notes-koKR: 새로운 애드온 개발을 위한 기본 템플릿입니다.

# 파일 로드 순서도 중요합니다.
# 1. 현지화 텍스트 먼저 로드
Locales.lua
# 2. UI 프레임(XML) 로드
Frames.xml
# 3. 핵심 로직(Lua) 로드
Core.lua
```

#### **📄 파일 설명**
*   `## Interface: 100207`: 애드온이 호환되는 WoW 클라이언트 버전입니다. **이 숫자는 패치마다 바뀌므로 항상 최신 버전으로 유지해야 합니다.** (10.2.7 패치 기준)
*   `## Title` / `## Notes`: 애드온의 영문 이름과 설명입니다.
*   `## Title-koKR` / `## Notes-koKR`: 한글 클라이언트에서 보일 이름과 설명입니다. `|cffFFFF00...|r` 코드는 글자색을 노란색으로 만듭니다.
*   `## Author`: 제작자 이름입니다.
*   `## Version`: 애드온 버전입니다.
*   `## SavedVariables: MyCoolAddonDB`: 애드온의 설정을 저장할 전역 변수 이름을 지정합니다. 이 변수는 캐릭터별 또는 계정 전체에 걸쳐 데이터를 저장하는 데 사용됩니다.
*   `Locales.lua`, `Frames.xml`, `Core.lua`: WoW 클라이언트가 로드할 파일 목록입니다. 일반적으로 **데이터 -> UI -> 로직** 순서로 로드하는 것이 안정적입니다.

---

### 2. `Locales.lua` - 현지화(언어) 파일

다양한 언어를 지원하기 위한 텍스트를 관리하는 파일입니다.

```lua
-- 애드온의 전역 테이블이 없으면 생성
MyCoolAddon = MyCoolAddon or {}

-- 현지화 텍스트를 담을 테이블
local L = {}

-- 게임 클라이언트의 언어 설정 가져오기 (e.g., "enUS", "koKR")
local locale = GetLocale()

if locale == "koKR" then
    -- 한글
    L["WELCOME_MESSAGE"] = "나의 멋진 애드온이 로드되었습니다! /mca 를 입력하여 테스트하세요."
    L["BUTTON_TEXT"] = "클릭!"
    L["BUTTON_CLICK_MESSAGE"] = "버튼이 클릭되었습니다!"

else
    -- 기본값 (영어)
    L["WELCOME_MESSAGE"] = "MyCoolAddon has been loaded! Type /mca to test."
    L["BUTTON_TEXT"] = "Click Me!"
    L["BUTTON_CLICK_MESSAGE"] = "The button was clicked!"
end

-- 다른 파일에서 L 테이블을 사용할 수 있도록 전역 테이블에 추가
MyCoolAddon.L = L
```

#### **📄 파일 설명**
*   `GetLocale()` 함수로 현재 게임 언어를 가져와서 그에 맞는 텍스트를 `L` 테이블에 저장합니다.
*   이렇게 분리해두면 나중에 다른 언어를 추가하기 매우 편리합니다.
*   `MyCoolAddon.L = L` 코드를 통해 `Core.lua` 같은 다른 파일에서 `MyCoolAddon.L["WELCOME_MESSAGE"]` 형태로 텍스트를 쉽게 가져다 쓸 수 있습니다.

---

### 3. `Frames.xml` - UI 프레임 정의 파일

XML을 사용해 애드온의 UI 요소(창, 버튼 등)를 시각적으로 구성합니다. Lua로만 만드는 것보다 구조적으로 깔끔하고 유지보수가 쉽습니다.

```xml
<Ui xmlns="http://www.blizzard.com/wow/ui/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.blizzard.com/wow/ui/
..\FrameXML\UI.xsd">

    <!-- 슬래시(/) 명령어 처리를 위한 프레임 -->
    <Frame name="MyCoolAddonSlashCommandHandler">
        <Scripts>
            <OnLoad>
                -- /mca 와 /mycooladdon 명령어를 등록하고, MyCoolAddon.SlashCommandHandler 함수를 호출하도록 설정
                SLASH_MYCOOLADDON1 = "/mycooladdon";
                SLASH_MYCOOLADDON2 = "/mca";
                SlashCmdList["MYCOOLADDON"] = MyCoolAddon.SlashCommandHandler;
            </OnLoad>
        </Scripts>
    </Frame>

    <!-- 애드온 메인 프레임 (창) -->
    <Frame name="MyCoolAddonFrame" parent="UIParent" movable="true" enableMouse="true" hidden="true">
        <Size x="250" y="150"/>
        <Anchors>
            <Anchor point="CENTER"/>
        </Anchors>
        <Backdrop bgFile="Interface/DialogFrame/UI-DialogBox-Background" edgeFile="Interface/DialogFrame/UI-DialogBox-Border" tile="true">
            <EdgeSize val="16"/>
            <TileSize val="32"/>
            <BackgroundInsets>
                <AbsInset left="5" right="5" top="5" bottom="5"/>
            </BackgroundInsets>
        </Backdrop>
        <Layers>
            <!-- 창 제목 -->
            <Layer level="ARTWORK">
                <FontString name="$parentTitle" inherits="GameFontNormal" text="MyCoolAddon">
                    <Anchors>
                        <Anchor point="TOP" y="-10"/>
                    </Anchors>
                </FontString>
            </Layer>
        </Layers>
        <Frames>
            <!-- 테스트 버튼 -->
            <Button name="$parentButton" inherits="UIPanelButtonTemplate">
                <Size x="100" y="25"/>
                <Anchors>
                    <Anchor point="CENTER" y="0"/>
                </Anchors>
                <Scripts>
                    <OnClick>
                        -- 버튼 클릭 시 Core.lua에 정의된 함수 호출
                        MyCoolAddon.MyCoolAddonFrameButton_OnClick(self);
                    </OnClick>
                </Scripts>
            </Button>
        </Frames>
        <Scripts>
            <OnLoad>
                -- 프레임을 마우스로 드래그하여 이동할 수 있게 설정
                self:RegisterForDrag("LeftButton");
            </OnLoad>
            <OnDragStart>
                self:StartMoving();
            </OnDragStart>
            <OnDragStop>
                self:StopMovingOrSizing();
            </OnDragStop>
        </Scripts>
    </Frame>
</Ui>
```

#### **📄 파일 설명**
*   **SlashCommandHandler**: 눈에 보이지 않는 프레임으로, 슬래시 명령어를 등록하는 역할만 합니다.
*   **MyCoolAddonFrame**: 실제 유저에게 보이는 창입니다. `parent="UIParent"`로 기본 UI의 자식으로 만들고, `movable="true"`로 이동 가능하게 합니다. `hidden="true"`로 처음에는 숨겨둡니다.
*   **Backdrop**: 창의 배경과 테두리를 설정합니다.
*   **Button**: `UIPanelButtonTemplate`을 상속받아 기본 버튼 스타일을 사용합니다. `<OnClick>` 스크립트에서 Lua 함수를 호출합니다.

---

### 4. `Core.lua` - 핵심 로직 파일

애드온의 모든 기능과 로직이 담기는 파일입니다.

```lua
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
```

#### **📄 파일 설명**
*   `MyCoolAddonDB = MyCoolAddonDB or defaults`: `.toc`에서 `SavedVariables`로 지정한 `MyCoolAddonDB`가 존재하는지 확인하고, 없으면(최초 실행 시) `defaults` 테이블로 초기화합니다.
*   `OnLoad()`: 애드온이 완전히 로드되었을 때 한 번 실행되어 초기 설정을 담당합니다.
*   `SlashCommandHandler(msg)`: XML에서 등록한 슬래시 명령어를 처리합니다. `msg`는 명령어 뒤에 오는 문자열입니다(예: `/mca show`에서 `msg`는 "show").
*   `MyCoolAddonFrameButton_OnClick()`: XML의 버튼이 클릭될 때 호출될 함수입니다.
*   **이벤트 핸들링**: `ADDON_LOADED` 이벤트를 받아 자신의 애드온 이름이 맞는지 확인 후 초기화 함수(`OnLoad`)를 실행하는 것이 가장 안정적인 초기화 방법입니다.

### 🎮 사용 방법 및 테스트

1.  위에 설명된 대로 `MyCoolAddon` 폴더와 4개의 파일을 WoW 설치 폴더의 `_retail_/Interface/AddOns/` 내에 넣습니다.
2.  WoW를 실행하고 캐릭터 선택 화면의 왼쪽 아래 **'애드온'** 버튼을 클릭하여 '나의 멋진 애드온'이 목록에 있는지, 체크되어 있는지 확인합니다.
3.  게임에 접속하면 채팅창에 "나의 멋진 애드온이 로드되었습니다!..." 메시지가 출력되는지 확인합니다.
4.  채팅창에 `/mca` 또는 `/mycooladdon`을 입력하면 'MyCoolAddon' 창이 나타나는지, 다시 입력하면 사라지는지 확인합니다.
5.  창에 있는 '클릭!' 버튼을 누르면 채팅창에 "버튼이 클릭되었습니다!" 메시지가 출력되는지 확인합니다.

이제 이 템플릿을 기반으로 원하시는 기능을 자유롭게 추가하며 멋진 애드온을 개발해 보세요

네, 그럼요! WoW 애드온 개발에서 `SavedVariables`는 애드온의 "기억"을 담당하는 핵심 기능입니다. 사용자의 설정을 게임 세션 간에 유지하는 방법을 더 자세하고 체계적으로 알려드리겠습니다.

### 🧠 `SavedVariables`의 핵심 원리

`SavedVariables`의 작동 원리는 생각보다 간단합니다.

1.  **선언**: 개발자가 `.toc` 파일에 "이 전역 변수는 저장될 거야"라고 WoW 클라이언트에 알려줍니다.
2.  **로드**: 게임이 시작되고 애드온을 로드할 때, WoW 클라이언트는 이전에 저장된 데이터가 있는지 확인합니다.
    *   **데이터가 있으면**: 저장된 데이터를 불러와 `.toc`에 명시된 이름의 **전역 Lua 변수**로 만들어 줍니다.
    *   **데이터가 없으면 (최초 실행)**: 해당 변수는 `nil` 상태로 남아있습니다.
3.  **수정**: 애드온 코드 내에서 이 전역 변수(실제로는 Lua 테이블)의 값을 자유롭게 읽고 수정합니다.
4.  **저장**: 사용자가 로그아웃하거나, UI를 리로드(`/reload`)하거나, 게임을 정상적으로 종료할 때, WoW 클라이언트는 해당 전역 변수의 **현재 상태**를 파일로 자동 저장합니다.

**가장 중요한 점**: 개발자는 파일을 직접 읽고 쓰는 코드를 짤 필요가 없습니다. WoW가 모든 것을 자동으로 처리해주므로, 우리는 그저 약속된 Lua 테이블을 사용하기만 하면 됩니다.

---

### ⚖️ 계정 공통 vs. 캐릭터별 저장 (`SavedVariables` vs. `SavedVariablesPerCharacter`)

두 가지 저장 방식이 있으며, 용도에 맞게 선택해야 합니다.

| 구분 | `## SavedVariables` | `## SavedVariablesPerCharacter` |
|---|---|---|
| **저장 범위** | **계정 전체**에 공통으로 적용 | **캐릭터마다** 개별적으로 저장 |
| **변수 이름** | `.toc` 파일에 지정한 이름 그대로 사용 | `.toc`에 지정한 이름 그대로 사용 |
| **주요 용도** | - 애드온 전반의 설정 (예: 스킨, 폰트 크기)<br>- 계정 전체 통계 (예: 총 골드 획득량)<br>- 다른 애드온과 공유할 데이터 | - UI 창 위치, 크기<br>- 캐릭터별 활성화/비활성화 설정<br>- 특정 직업/전문화에 맞는 설정 |
| **저장 파일 위치** | `WTF/.../SavedVariables/애드온이름.lua` | `WTF/.../서버명/캐릭터명/SavedVariables/애드온이름.lua` |

**💡 실전 팁**: 대부분의 애드온은 두 가지를 모두 사용합니다. 계정 공통 설정과 캐릭터별 설정을 분리하여 관리하는 것이 훨씬 깔끔합니다.

---

### 📝 단계별 구현 가이드 (실전 예제)

이전 템플릿을 확장하여, 창 위치는 **캐릭터별**로 저장하고, 버튼이 클릭된 횟수는 **계정 전체**에 누적하여 저장하는 기능을 만들어 보겠습니다.

#### 1단계: `.toc` 파일에 변수 선언

`.toc` 파일에 두 종류의 저장 변수를 모두 추가합니다.

**`MyCoolAddon.toc`**
```toc
## Interface: 100207
## Title: MyCoolAddon
## ... (이전 내용과 동일) ...

## SavedVariables: MyCoolAddon_AccountDB
## SavedVariablesPerCharacter: MyCoolAddon_CharDB

## Title-koKR: |cffFFFF00나의 멋진 애드온|r
## Notes-koKR: 새로운 애드온 개발을 위한 기본 템플릿입니다.

# ... (파일 로드 목록) ...
```
*   `MyCoolAddon_AccountDB`: 계정 공통 데이터를 위한 변수입니다.
*   `MyCoolAddon_CharDB`: 캐릭터별 데이터를 위한 변수입니다.
*   변수 이름에 애드온 이름을 접두사로 붙이는 것은 다른 애드온과의 충돌을 피하기 위한 좋은 습관입니다.

#### 2단계: `Core.lua`에서 변수 초기화 및 기본값 설정

애드온이 로드될 때, 저장된 변수가 `nil`인지 확인하고, `nil`이라면(최초 실행) 기본값을 설정해주는 코드를 작성해야 합니다.

**`Core.lua`**
```lua
MyCoolAddon = MyCoolAddon or {}
local L = MyCoolAddon.L

-- 1. 기본값 테이블 정의
local account_defaults = {
    totalClicks = 0,
}
local char_defaults = {
    -- 창 위치: { point, relativeTo, relativePoint, xOfs, yOfs }
    framePosition = { "CENTER", "UIParent", "CENTER", 0, 0 },
}

-- 2. 애드온 로드 시 실행될 함수
function MyCoolAddon:OnLoad()
    -- 2-1. 계정 공통 DB 초기화
    -- MyCoolAddon_AccountDB가 nil이면 account_defaults 테이블로 초기화
    MyCoolAddon_AccountDB = MyCoolAddon_AccountDB or account_defaults

    -- 2-2. 캐릭터별 DB 초기화
    -- MyCoolAddon_CharDB가 nil이면 char_defaults 테이블로 초기화
    MyCoolAddon_CharDB = MyCoolAddon_CharDB or char_defaults

    -- 3. 저장된 값 불러와서 적용하기
    -- 창 위치 적용
    local pos = MyCoolAddon_CharDB.framePosition
    MyCoolAddonFrame:SetPoint(pos[1], pos[2], pos[3], pos[4], pos[5])
    
    print(L["WELCOME_MESSAGE"])
    print("Total Clicks (Account-wide): " .. MyCoolAddon_AccountDB.totalClicks) -- 저장된 클릭 횟수 출력

    MyCoolAddonFrameButton:SetText(L["BUTTON_TEXT"])
end

-- ... (SlashCommandHandler는 이전과 동일) ...

-- 4. 데이터 수정 및 저장
function MyCoolAddon.MyCoolAddonFrameButton_OnClick(self)
    -- 계정 공통 DB 값 수정
    MyCoolAddon_AccountDB.totalClicks = MyCoolAddon_AccountDB.totalClicks + 1
    
    print(L["BUTTON_CLICK_MESSAGE"])
    print("New total clicks: " .. MyCoolAddon_AccountDB.totalClicks)
end


-- ============================================================================
-- 창 이동이 끝났을 때 위치 저장
-- ============================================================================
-- Frames.xml의 MyCoolAddonFrame -> Scripts -> OnDragStop에 이 코드를 추가하거나,
-- Lua에서 직접 스크립트를 설정할 수 있습니다.
MyCoolAddonFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()

    -- 5. 캐릭터별 DB에 현재 창 위치 저장
    -- GetPoint()는 point, relativeTo, relativePoint, xOfs, yOfs를 순서대로 반환합니다.
    MyCoolAddon_CharDB.framePosition = { self:GetPoint() }

    print("Frame position saved for this character.")
end)


-- ... (이벤트 핸들러 프레임은 이전과 동일) ...
```

#### 3단계: `Frames.xml` 파일 수정 (선택사항)

`Core.lua`에서 `SetScript`로 처리했기 때문에 XML을 수정할 필요는 없지만, 만약 XML에서 직접 처리하고 싶다면 아래와 같이 할 수 있습니다.

**`Frames.xml`**
```xml
<!-- MyCoolAddonFrame의 Scripts 섹션 -->
<Scripts>
    <OnLoad>
        self:RegisterForDrag("LeftButton");
    </OnLoad>
    <OnDragStart>
        self:StartMoving();
    </OnDragStart>
    <OnDragStop>
        self:StopMovingOrSizing();
        -- Lua 함수를 호출하여 위치 저장 로직 실행
        MyCoolAddon.SaveFramePosition(self);
    </OnDragStop>
</Scripts>
```
이 경우 `Core.lua`에 `MyCoolAddon.SaveFramePosition(frame)` 함수를 만들어야 합니다. Lua에서 직접 `SetScript` 하는 것이 더 관리하기 편할 수 있습니다.

### 🎮 테스트 시나리오

1.  **최초 실행**: 게임 접속 시 "Total Clicks: 0"이 출력됩니다.
2.  **버튼 클릭**: 버튼을 5번 클릭합니다. 매번 "New total clicks: 1", "New total clicks: 2" ... 가 출력됩니다.
3.  **UI 리로드**: `/reload`를 입력합니다. 리로드 후 "Total Clicks: 5"가 출력됩니다. (값이 저장되었음!)
4.  **창 이동**: `/mca`로 창을 열고 구석으로 드래그합니다. "Frame position saved..." 메시지가 출력됩니다.
5.  **UI 리로드**: `/reload`를 입력합니다. 창이 이전에 옮겨놓은 **그 구석 위치**에 다시 나타납니다.
6.  **다른 캐릭터 접속**: 다른 캐릭터로 접속합니다.
    *   "Total Clicks: 5"가 출력됩니다. (계정 공통 데이터는 공유됨)
    *   `/mca`로 창을 열면 **화면 중앙**에 나타납니다. (캐릭터별 데이터는 공유되지 않음)

### ⚠️ 주의사항 및 팁

*   **저장할 수 없는 데이터**: UI 프레임 자체, 함수, 스레드 같은 복잡한 `userdata` 타입은 저장할 수 없습니다. 오직 **테이블, 문자열, 숫자, 불리언** 값만 저장하세요.
*   **nil 값**: 테이블 내에 `nil` 값을 가진 키는 저장되지 않습니다. 값을 제거하고 싶으면 `MyCoolAddonDB.someKey = nil`로 설정하면 됩니다.
*   **성능**: `SavedVariables`에 너무 거대하고 복잡한 테이블을 저장하면 게임 로딩/종료 시간에 영향을 줄 수 있습니다. 꼭 필요한 데이터만 저장하는 것이 좋습니다.
*   **백업**: `SavedVariables` 파일은 WoW 설치 폴더 내의 `WTF` 폴더에 있습니다. 애드온 개발 중에는 이 폴더를 가끔 백업해두면 좋습니다.
