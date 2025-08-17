params["_unitName" , "_side"];

private _colorString = switch (_side) do {
	case west:      { "#155DFC" };
	case east:       { "#C11007" };
	case resistance: { "#178236" };
	default             { "#FFFFFF" };
};

format ["<font color='%1'>%2</font>", _colorString, _unitName]