package com.monsters.halloween {

    public class HalloweenGoodiePopup extends HalloweenPopup {

        private static const PUMPKINS:String = "events/halloween/hwn_goodie_pumpkins.png";

        private static const BODY_COLOUR:uint = 0x6a2800;

        private static const DECORATIONS_MENU:int = 4;

        private static const SPECIAL_SUBMENU:int = 4;

        public function HalloweenGoodiePopup() {
            m_boxWidth = 545;
            m_boxHeight = 265;
            m_title = KEYS.Get("hwn_goodie_title");
            m_isTitleCentred = true;
            m_titleY = 16;
            m_textX = 140;
            m_textWidth = 348;
            m_body = "<b>" + coloured(KEYS.Get("hwn_goodie_awarded", {"v1": HalloweenEvent.SHINY_REWARD}), TITLE_COLOUR) + "</b><br>" + KEYS.Get("hwn_goodie_body");
            m_bodyColour = BODY_COLOUR;
            m_bodySize = 18;
            m_bodyY = 78;
            m_buttonLabel = KEYS.Get("hwn_goodie_btn");
            m_buttonX = 16;
            m_buttonY = 200;
            m_buttonWidth = 497;
            m_graphic = PUMPKINS;
            m_graphicX = 12;
            m_graphicY = 70;
            m_graphicScale = 1.63;
        }

        public static function showGoodies():void {
            BUILDINGS._menuA = DECORATIONS_MENU;
            BUILDINGS._menuB = SPECIAL_SUBMENU;
            BUILDINGS._page = 0;
            BUILDINGS.Show();
        }
    }
}
