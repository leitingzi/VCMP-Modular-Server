
/*
Map ��˵���ĵ�
����
	Map ���ǻ��ڼ�ֵ�ԣ�Pair����ӳ�����������ڴ洢�͹����ֵ�������ݼ��ϣ��ṩ�˷ḻ�Ĳ���������
��������
	static Type = "Map": ���ʶ
	list: �ڲ��洢�� Pair �б�
	size: ӳ���м�ֵ�Ե�����
���췽��
	Map(...)
	�ɽ��ն�� Pair ʵ����Ϊ������ʼ��ӳ��

��Ҫ����
	��Ӳ���
		add(pair): ��� Pair ʵ���������Ѵ������滻��
		addAll(otherMap): �ϲ���һ�� Map������ͻʱ�ۼ�ֵ��
		put(key, e): ͨ����ֱֵ����ӣ��Զ����� Pair��
	��ѯ����
		get(key): ��ȡָ������ֵ
		getOrDefault(key, d): ��ȡֵ���������򷵻�Ĭ��ֵ d
		getOrNull(key): ��ȡֵ���������򷵻� null
		hasKey(key): �ж��Ƿ����ָ����
		contain(pair): �ж��Ƿ����ָ�� Pair
		keys(): �������м����б�
		values(): ��������ֵ���б�
	�޸���ɾ��
		remove(key): �Ƴ�ָ�����ļ�ֵ��
		clear(): ������м�ֵ��
	������ת��
		forEach(f): �������� Pair ��ִ�к��� f
		forEachValue(f): ��������ֵ��ִ�к��� f
		map(f): ��ÿ��ֵӦ�ú��� f�������� Map
		filter(f): ���˷��������� Pair�������� Map
		isEmpty(): �ж�ӳ���Ƿ�Ϊ��
		_tostring(): ת��Ϊ�ַ�����ʾ
	���л�
		static fromSaveString(string, f): �ӱ����ַ�������Ϊ Map ʵ��
		getSaveString(f): ת��Ϊ�ɱ�����ַ�����ʽ
����˵��
	�ڲ����� List �洢 Pair ʵ��
	������Ψһ�ԣ�����ظ������Զ��滻��ֵ
	���в������Զ�ά�� size ���Ե�׼ȷ��
	��֧�� Pair �������ݴ洢��ȷ�����Ͱ�ȫ
*/

class Map extends Any {
	static Type = "Map";
	list = null;
	size = null;

	constructor(...){
		list = List();
		for (local i = 0; i < vargv.len(); i++) {
			add(vargv[i]);
		}
		size = list.size;
	}

	function add(pair) {
		if(typeof pair != Pair.Type) {
			throw "Mapֻ�ܴ���" + Pair.Type + "���͵�����";
		}
		if(contain(pair)) {
			remove(pair.key);
		}
		list.add(pair);
		size = list.size;
	}

	function addAll(otherMap) {
		local thisPack = this;
		otherMap.forEach(function (pair) {
			if(thisPack.hasKey(pair.key)) {
				thisPack.put(pair.key, thisPack.get(pair.key) + pair.value);
			} else {
				thisPack.add(pair);
			}
		});
	}

	function put(key, e) {
		return add(Pair(key, e));
	}

	function contain(pair) {
		return hasKey(pair.key);
	}

	function remove(key) {
		local findIndex = list.findFrom(@(v) v.key == key);
		if(findIndex != null) {
			list.removeIndex(findIndex);
			size = list.size;
		}
	}

	function get(key) {
		return getOrNull(key);
	}

	function getOrDefault(key, d) {
		local findIndex = list.findFrom(@(v) v.key == key);
		return findIndex != null ? list.get(findIndex).value : d
	}

	function getOrNull(key) {
		return getOrDefault(key, null);
	}

	function hasKey(key) {
		return list.filter(@(v) v.key == key).size > 0 ? true : false;
	}

	function keys() {
		return list.map(@(v) v.key);
	}

	function values() {
		return list.map(@(v) v.value);
	}

	function clear() {
		list.clear();
	}

	function isEmpty() {
		return list.size == 0;
	}

	function forEach(f) {
		list.forEach(f);
	}

	function forEachValue(f) {
		for (local i = 0; i < list.size; i++) {
			f(list.get(i).value);
		}
	}

	function map(f) {
		local newMap = Map();
		for (local i = 0; i < list.size; i++) {
			local pair = list.get(i);
			newMap.put(pair.key, f(pair.value));
		}
		return newMap;
	}

	function filter(f) {
		local newMap = Map();
		for (local i = 0; i < list.size; i++) {
			local pair = list.get(i);
			if(f(pair)) {
				newMap.add(pair);
			}
		}
		return newMap;
	}

	function _tostring() {
		return list.tostring();
	}
}