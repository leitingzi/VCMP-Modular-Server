
/*
Pair ��˵���ĵ�
����
	Pair ����һ����ֵ�����������ڴ洢�͹����ֵ�������ݣ��ṩ�˼�ֵ�ԵĴ�����ת�����Ƚϵȹ��ܡ�
��������
	static Type = "Pair": ���ʶ
	key: ��ֵ�Եļ�������Ϊ null��
	value: ��ֵ�Ե�ֵ
���췽��
	Pair(key, value = null)
	����:
		key: �����������Ϊ�գ�
		value: ֵ����ѡ��Ĭ��Ϊ null��
	�쳣���� key Ϊ null ʱ�׳��쳣 "Pair ���͵� Key ����Ϊ��"

��̬����
	fromSaveString(string): �ӱ�����ַ����н��������� Pair ʵ��
	Type: �ྲ̬��ʶ����

ʵ������
	getSaveString(): �� Pair ʵ��ת��Ϊ�ɱ�����ַ�����ʽ
	create(table): �ӱ�����ݴ��� Pair ʵ������ȡ��һ����Ч��ֵ�ԣ�
	_tostring(): ת��Ϊ�ַ�����ʾ����ʽ: "key to value"��
	_cmp(other): ����һ�� Pair ʵ���Ƚϣ����� value ֵ��
	equal(other): �ж�����һ�� Pair ʵ���Ƿ���ȣ�����ֵ������ȣ�
	toTable(): ת��Ϊ�����ʽ��{key, value}��
	reverse(): ��������ֵ�����ص�ǰʵ��
	copy(newKey = null, newValue = null): ������������ָ���µļ���ֵ

��Ҫ����
	��ȫ�ļ�ֵ�Թ���ȷ������Ϊ�գ�
	֧�����л��ͷ����л�������ͻָ����ݣ�
	�ṩ���ָ�ʽת�����ַ��������
	֧�ֱȽϺ͸��Ʋ���
	�ɽ�����ֵ��ϵ
*/

class Pair extends Any {
	static Type = "Pair";
	key = null;
	value = null;

	constructor(key, value = null) {
		if (key == null) {
			throw "Pair���͵�Key����Ϊ��";
		}

		this.key = key;
		this.value = value;
	}

	static function fromSaveString(string) {
		local e = getValueAndType(string, "&", "*");
		if (e.type == Type) {
			local valueType = e.valueArray[2];
			local key = e.valueArray[1];
			local value = TypeConver.Conver(valueType, e.valueArray[0]);
			return Pair(key, value);
		} else {
			return null;
		}
	}

	function getSaveString() {
		return TypeConver.getSaveString(value) + "*" + key + "*" + typeof value + "&" + Type;
	}

	function create(table) {
		foreach(i, value in table) {
			if (i == null) {
				continue;
			}
			this.key = i;
			this.value = value;
			break;
		}
		if (this.key == null) {
			throw "Pair���͵�Key����Ϊ��";
		}
		return this;
	}

	function _tostring() {
		return key + " to " + value;
	}

	function _cmp(other) {
		if (value < other.value) return -1;
		if (value > other.value) return 1;
		return 0;
	}

	function equal(other) {
		return value == other.value && key == other.key;
	}

	function toTable() {
		return {
			key = this.key,
			value = this.value
		};
	}

	function reverse() {
		local key = this.key;
		this.key = this.value;
		this.value = key;
		return this;
	}

	function copy(newKey = null, newValue = null) {
		return Pair(newKey != null ? newKey : this.key, newValue != null ? newValue : this.value);
	}
}