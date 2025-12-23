class 29th_Training {
  tag = "Hill";
  class 29th {
    file = "functions\29th_Training";
    class enter_spectator {};
    class exit_spectator {};
    class setInsignia {};
    class noThermals {};
    class addRadio {};
    class arsenalClosed {};
    class removeRadio {};
    class assignCurator {};
    class handleInitialInventory {}; 
    class checkCuratorAssignment {};    

    #ifdef DOTT_TRAINING
    class cleaner {};
    #endif

    #ifdef DOTT_EVENT
    class cleaner_event {};
    #endif
  };
};