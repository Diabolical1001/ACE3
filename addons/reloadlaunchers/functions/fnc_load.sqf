/*
 * Author: commy2
 * Reload a launcher
 *
 * Argument:
 * 0: Unit with magazine (Object)
 * 1: Unit with launcher (Object)
 * 2: weapon name (String)
 * 3: missile name (String)
 *
 * Return value:
 * NONE
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_unit", "_target", "_weapon", "_magazine"];
TRACE_4("params",_unit,_target,_weapon,_magazine);

private "_reloadTime";
_reloadTime = getNumber (configFile >> "CfgWeapons" >> _weapon >> "magazineReloadTime");

// do animation
[_unit] call EFUNC(common,goKneeling);

// show progress bar
private ["_onSuccess", "_onFailure", "_condition"];

_onSuccess =  {
    (_this select 0 select 0) removeMagazine (_this select 0 select 3);
    ["reloadLauncher", _this select 0 select 1, _this select 0] call DEFUNC(common,targetEvent);

    [localize LSTRING(LauncherLoaded)] call DEFUNC(common,displayTextStructured);
};

_onFailure = {
    [localize ELSTRING(common,ActionAborted)] call DEFUNC(common,displayTextStructured);
};

_condition = {
    (_this select 0) call DFUNC(canLoad) && {(_this select 0 select 0) distance (_this select 0 select 1) < 4}
};

[_reloadTime, [_unit, _target, _weapon, _magazine], _onSuccess, _onFailure, localize LSTRING(LoadingLauncher), _condition] call EFUNC(common,progressBar);
