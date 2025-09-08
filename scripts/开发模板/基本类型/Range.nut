
/*
Range ��˵���ĵ�
����
	Range �������ڹ�����ֵ��Χ�������򸡵������Ĺ����࣬�ṩ��Χ��顢���ֵ���ɡ����л��ȹ��ܣ���������Ҫ��ֵ����Լ���ĳ�����
��������
	static Type = "Range": ���ʶ�����������жϺ����л�
	value1: ��Χ����ʼֵ�������򸡵�����
	value2: ��Χ�Ľ���ֵ�������򸡵�����
���췽��
	Range(value1, value2)

����Ҫ��value1 �� value2 ������������integer���򸡵�����float��
�쳣�׳������������Ͳ�����Ҫ���׳� Range�Ĳ��������������򸡵��� �쳣

��̬����
WithIn(v1, v2, i)		�����ֵ i �Ƿ��� [v1, v2] ��������	- v1����Χ��ʼֵ- v2����Χ����ֵ- i���������ֵ			 ����ֵ��true ��ʾ�ڷ�Χ�ڣ�false ��֮��
fromSaveString(string)	�����л��ַ�������Ϊ Range ʵ��	string��ͨ�� getSaveString() ���ɵı����ַ���				�����ɹ����� Range ʵ����ʧ�ܷ��� null

ʵ������
_tostring()			ת��Ϊ�׶����ַ�����ʽ													��						�ַ�������ʽ��Range(��ʼֵ .. ����ֵ)���� Range(1 .. 10)��
checkIn(v)			�����ֵ v �Ƿ��ڵ�ǰʵ���� [value1, value2] ��������					v���������ֵ				����ֵ��true ��ʾ�ڷ�Χ�ڣ�false ��֮��
untilIn(v)			�����ֵ v �Ƿ��ڵ�ǰʵ���� (value1, value2) �������ڣ��������߽磩		v���������ֵ				����ֵ��true ��ʾ�ڷ�Χ�ڣ�false ��֮��
rand()				�ڵ�ǰʵ���� [value1, value2] ��Χ���������ֵ							��						������� / ���������� value1/value2 ����һ�£�
getSaveString()		����ǰ Range ʵ�����л�Ϊ�ַ��������ڱ������							��							���л��ַ�������ʽ��value1_value2:Range���� 1_10:Range��

��������
	���Ͱ�ȫ��ǿ�����Ʒ�ΧֵΪ�����򸡵���������Ƿ����ʹ���
	��������飺֧�ֱ����䣨checkIn���Ϳ����䣨untilIn�����ַ�Χ�ж��߼�
	���л�֧�֣�ͨ�� fromSaveString �� getSaveString ʵ��ʵ���ı�����ָ�
	���ֵ������ɣ�ֱ�ӵ��� rand() ���ɻ�ȡ��Χ�ڵ����ֵ��������⴦��
*/

class Range extends Any {
	static Type = "Range";
	value1 = null;
	value2 = null;

	constructor(value1, value2) {
		if ((typeof value1 == "integer" || typeof value1 == "float") && (typeof value2 == "integer" || typeof value2 == "float")) {
			this.value1 = value1;
			this.value2 = value2;
		} else {
			throw Type + "�Ĳ��������������򸡵���";
		}
	}

	static function WithIn(v1, v2, i) {
		return i >= v1 && i <= v2;
	}

	function _tostring() {
		return Type + "(" + value1 + " .. " + value2 + ")";
	}

	function checkIn(v) {
		return v >= value1 && v <= value2;
	}

	function untilIn(v) {
		return v > value1 && v < value2;
	}

	function rand() {
		return Rand.inRanger(this);
	}

	static function fromSaveString(string) {
		local e = getValueAndType(string);
		if (e.type == Type) {
			local value1 = e.valueArray[0].tofloat();
			local value2 = e.valueArray[1].tofloat();
			return Range(value1, value2);
		} else {
			return null;
		}
	}

	function getSaveString() {
		return value1 + "_" + value2 + ":" + Type;
	}
}