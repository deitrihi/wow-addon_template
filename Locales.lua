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