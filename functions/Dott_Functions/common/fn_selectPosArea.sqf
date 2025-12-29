/*
 * Name:	DOTT_fnc_selectPosArea
 * Date:	3/7/2024
 * Version: 1.0
 * Author:  Dott [29th ID]
 *
 * Description:
 * Selects a random position in a given area
 * Works with any marker shape, or a polygon
 * Can also return areas in a "band" (donut shaped) area for ellipses and rectangles
 *
 * Parameter(s):
 * _areaType (String): Type of area (CIRCLE,ELLIPSES,RECTANGLE,POLYGON)
 * _position (String or position): Marker string name or position data
 * _band (Bool): True if area selected should be in a band (default: false) (CIRCLE, ELLIPSES, RECTANGLE ONLY)
 * _bandSize (number): Band width in meters
 *
 * Returns:
 * random position in given area
 */

params ["_PARAM1", "_PARAM2"];


//BIS_fnc_randomPosTrigger - good for rectangle and ellipses
//circle will be easier with getPos and random, especially for band type request
//Polygons will be hard, likely need to randomly select positions in rectangle until you find one in poly
//Possibly many recursions... best offloaded to server, remoteExecCall