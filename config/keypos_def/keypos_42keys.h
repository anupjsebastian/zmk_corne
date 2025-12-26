/*
 * Key Position Definitions for 42-key Corne Layout
 * 
 * Visual representation of key positions:
 * 
 * ╭────────────────────────────╮ ╭────────────────────────────╮
 * │  0   1   2   3   4   5     │ │     6   7   8   9  10  11  │
 * │ 12  13  14  15  16  17     │ │    18  19  20  21  22  23  │
 * │ 24  25  26  27  28  29     │ │    30  31  32  33  34  35  │
 * ╰───────────╮ 36  37  38     │ │    39  40  41 ╭────────────╯
 *             ╰────────────────╯ ╰───────────────╯
 */

#pragma once

// Left hand keys
#define LT0  0   // Top row
#define LT1  1
#define LT2  2
#define LT3  3
#define LT4  4
#define LT5  5

#define LM0 12   // Middle (home) row
#define LM1 13
#define LM2 14
#define LM3 15
#define LM4 16
#define LM5 17

#define LB0 24   // Bottom row
#define LB1 25
#define LB2 26
#define LB3 27
#define LB4 28
#define LB5 29

#define LH0 36   // Thumb keys
#define LH1 37
#define LH2 38

// Right hand keys
#define RT0  6   // Top row
#define RT1  7
#define RT2  8
#define RT3  9
#define RT4 10
#define RT5 11

#define RM0 18   // Middle (home) row
#define RM1 19
#define RM2 20
#define RM3 21
#define RM4 22
#define RM5 23

#define RB0 30   // Bottom row
#define RB1 31
#define RB2 32
#define RB3 33
#define RB4 34
#define RB5 35

#define RH0 39   // Thumb keys
#define RH1 40
#define RH2 41

// Useful groups
#define KEYS_L LT0 LT1 LT2 LT3 LT4 LT5 LM0 LM1 LM2 LM3 LM4 LM5 LB0 LB1 LB2 LB3 LB4 LB5  // All left hand keys
#define KEYS_R RT0 RT1 RT2 RT3 RT4 RT5 RM0 RM1 RM2 RM3 RM4 RM5 RB0 RB1 RB2 RB3 RB4 RB5  // All right hand keys
#define THUMBS LH0 LH1 LH2 RH0 RH1 RH2  // All thumb keys
