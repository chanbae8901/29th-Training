/*
 * File: eventNumbers.hpp
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Defines numeric event type constants for the tracker system.
 * Events are stored as numbers instead of strings to minimize
 * network payload when transmitting event data to clients.
 *
 * DELAY variants represent events where the causal hit occurred
 * DELAY_TIME seconds before the actual death/unconscious event.
 */

#define SECTOR_CAPTURE_NUM 0
#define ACE_CONSCIOUSNESS_NUM 1
#define INFANTRY_KILL_NUM 2
#define VEHICLE_KILL_NUM 3
#define DELAY_KILL_NUM 4
#define DELAY_ACE_CONSCIOUSNESS_NUM 5

#define DELAY_TIME 10
