//No #include script_macros.hpp since this is defined in there
#define ROUND_IDLE (EGVAR(round,state) isEqualTo 0)
#define ROUND_SAFE (EGVAR(round,state) isEqualTo 1)
#define ROUND_LIVE (EGVAR(round,state) isEqualTo 2)

#define NOT_ROUND_IDLE (EGVAR(round,state) isNotEqualTo 0)
#define NOT_ROUND_SAFE (EGVAR(round,state) isNotEqualTo 1)
#define NOT_ROUND_LIVE (EGVAR(round,state) isNotEqualTo 2)
