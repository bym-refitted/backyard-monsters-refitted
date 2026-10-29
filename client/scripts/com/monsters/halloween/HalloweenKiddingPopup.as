package com.monsters.halloween {

    public class HalloweenKiddingPopup extends HalloweenPopup {

        private static const GREETING_SIZE:int = 22;

        private static const BODY_SIZE:int = 18;

        private static const SHINY_SIZE:int = 24;

        public function HalloweenKiddingPopup() {
            m_boxWidth = 640;
            m_textWidth = 500;
            m_title = KEYS.Get("hwn_kidding_title") + " " + sized(KEYS.Get("hwn_kidding_greeting"), GREETING_SIZE);
            m_body = KEYS.Get("hwn_kidding_body", {"v1": sized(KEYS.Get("hwn_kidding_shiny", {"v1": HalloweenEvent.SHINY_REWARD}), SHINY_SIZE)});
            m_bodySize = BODY_SIZE;
            m_bodyY = 60;
            m_isBodyBold = true;
            m_buttonLabel = KEYS.Get("hwn_kidding_btn");
            m_buttonX = 14;
            m_buttonY = 142;
            m_buttonWidth = 405;
            m_graphicX = 389;
        }
    }
}
