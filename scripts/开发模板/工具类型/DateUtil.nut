class DateUtil {
	d = null;
	sec = null;
	min = null;
	hour = null;
	day = null;
	month = null;
	year = null;
	wday = null;
	yday = null;

	constructor() {
		d = date();
		update();
	}

	function update() {
		sec = d.sec;
		min = d.min;
		hour = d.hour;
		day = d.day;
		month = d.month;
		year = d.year;
		wday = d.wday;
		yday = d.yday;
	}

	function getToday(split = "/") {
		return (month + 1) + split + day;
	}

	function getCurrentTime(split = ":", hasSec = false) {
		return hour + split + (min < 10 ? "0" + min : min) + (hasSec ? split + sec : "");
	}
}