params["_name"];
private _num = DOTT_tracker_names find _name;
if (_num == -1) then 
{
	DOTT_tracker_names pushBack _name;
	_num = count DOTT_tracker_names - 1;
};

_num
