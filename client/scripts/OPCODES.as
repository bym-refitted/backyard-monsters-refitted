package
{
    public class OPCODES
    {

        public static const LOGIN:int = 1;
        public static const LOGIN_ERROR:int = 2;

        public static const DUPLICATE_SESSION:int = 5;

        public static const GET_NEW_MAP:int = 10;

        public static const BASE_SAVE:int = 100;
        public static const BASE_SAVE_ERROR:int = 101;

        public static const UPDATE_SAVE:int = 200;
        
        public static const PING:int = 500;

        public function OPCODES()
        {

            super();
        }
    }
}