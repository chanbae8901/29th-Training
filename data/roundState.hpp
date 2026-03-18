#define ROUND_IDLE (TN_round_state == 0)
#define ROUND_SAFE (TN_round_state == 1)
#define ROUND_LIVE (TN_round_state == 2)

#define NOT_ROUND_IDLE (TN_round_state != 0)
#define NOT_ROUND_SAFE (TN_round_state != 1)
#define NOT_ROUND_LIVE (TN_round_state != 2)
