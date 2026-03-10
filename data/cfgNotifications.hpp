    class Default
    {
        title = "";             // Tile displayed as text on black background. Filled by arguments.
        iconPicture = "";       // Small icon displayed in left part. Colored by "color", filled by arguments.
        iconText = "";          // Short text displayed over the icon. Colored by "color", filled by arguments.
        description = "";       // Brief description displayed as structured text. Colored by "color", filled by arguments.
        color[] = {1, 1, 1, 1}; // Icon and text color
        duration = 5;           // How many seconds will the notification be displayed
        priority = 0;           // Priority; higher number = more important; tasks in queue are selected by priority
        difficulty[] = {};      // Required difficulty settings. All listed difficulties has to be enabled
    };

    class General
    {
        title = "%1";
        description = "%2";
        iconPicture = "\A3\ui_f\data\map\mapcontrol\taskIcon_ca.paa";
        color[] = {1, 0.81, 0.06, 1};
        duration = 4;
        priority = 1;
    };

    class TimeWarning
    {
        title = "Time Warning";
        description = "%1";
        iconPicture = "\a3\Modules_F_Curator\Data\portraitCountdown_ca.paa";
        color[] = {1, 0.81, 0.06, 1};
        duration = 3;
        priority = 2;
    };

    class Reset
    {
        title = "%1";
        description = "%2";
        iconPicture = "a3\modules_f_curator\data\portraitrespawntickets_ca.paa";
        color[] = {1, 1, 1, 1};
        duration = 5;
        priority = 2;
    };

    class Document
    {
        title = "%1";
        description = "%2";
        iconPicture = "a3\ui_f\data\igui\cfg\simpletasks\types\documents_ca.paa";
        color[] = {1, 1, 1, 1};
        duration = 5;
        priority = 2;
    };

    class Health
    {
        title = "%1";
        description = "%2";
        iconPicture = "a3\characters_f\data\ui\icon_medic_ca.paa";
        color[] = {1, 1, 1, 1};
        duration = 5;
        priority = 2;
    };

    class FlagTaken
    {
        title = "%1";
        description = "%2";
        iconPicture = "ca\ui\data\markers\sc_marker_flagc_w_ca.paa";
        color[] = {1, 1, 1, 1};
        duration = 5;
        priority = 2;
    };

    class FlagCaptured
    {
        title = "%1";
        description = "%2";
        iconPicture = "ca\ui\data\markers\sc_marker_flag_w_ca.paa";
        color[] = {1, 1, 1, 1};
        duration = 5;
        priority = 2;
    };

    class FlagReturned
    {
        title = "%1";
        description = "%2";
        iconPicture = "a3\ui_f\data\igui\cfg\actions\returnflag_ca.paa";
        color[] = {1, 1, 1, 1};
        duration = 5;
        priority = 2;
    };
