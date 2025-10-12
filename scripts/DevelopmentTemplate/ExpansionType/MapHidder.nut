class MapHidder {
	hideMap = Map();

	function hide(id, pos) {
		::HideMapObject(id, pos.x, pos.y, pos.z);
	}
}