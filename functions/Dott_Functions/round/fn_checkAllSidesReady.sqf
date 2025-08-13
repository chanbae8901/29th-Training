private _bluCount = west countSide allPlayers;
private _opfCount = east countSide allPlayers;
private _grnCount = resistance countSide allPlayers;

//All sides are ready or have no players
(bluReady || _bluCount == 0) &&
(opfReady || _opfCount == 0) &&
(grnReady || _grnCount == 0)