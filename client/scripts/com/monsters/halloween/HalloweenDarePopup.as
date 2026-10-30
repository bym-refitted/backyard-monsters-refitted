package com.monsters.halloween {

    public class HalloweenDarePopup extends HalloweenPopup {

        private static const DOUBLE_DARE_SIZE:int = 21;

        private static const DOUBLE_DARE_WIDTH:int = 300;

        public function HalloweenDarePopup() {
            m_centreHeight = 0.72;
            m_isCloseTrick = true;
            m_boxWidth = 557;
            m_textWidth = 282;
            m_title = KEYS.Get("hwn_dare_title");
            m_body = KEYS.Get("hwn_dare_body");
            m_bodySize = 19;
            m_bodyY = 62;
            m_buttonLabel = KEYS.Get("hwn_dare_btn");
            m_buttonX = 14;
            m_buttonY = 149;
            m_buttonWidth = 323;
            m_graphicX = 306;
        }

        override protected function closeVanished():void {
            if (!m_bodyField)
                return;

            m_bodyField.width = DOUBLE_DARE_WIDTH;
            m_bodyField.htmlText = "<b>" + coloured(sized(KEYS.Get("hwn_dare_double"), DOUBLE_DARE_SIZE), TITLE_COLOUR) + "</b>";
            m_bodyField.height = m_bodyField.textHeight + 6;
        }
    }
}
