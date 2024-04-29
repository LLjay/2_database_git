-- �� �� �ּ�
/*

���� ��
�ּ�

*/

SELECT * FROM DBA_USERS; -- ���� ��� �����鿡 ���ؼ� ��ȸ�ϴ� ��ɹ�
-- ��ɹ� �� ���� ���� (������ ��� ��ư Ŭ�� | CTRL + ENTER
-- // Ư�� SQL�� �����ݷ��� �߿�, �����ݷ� ������ �׳� �� ��

-- �Ϲ� ����� ������ �����ϴ� ����(���� ������ ���������� �� �� �ִ�.)
-- [ǥ����] CREATE USER ������ IDENTIFIED BY ��й�ȣ;

CREATE USER KH IDENTIFIED BY KH;
-- ������ ��й�ȣ�� ��ҹ��ڸ� �����Ѵ�.

-- ������ ������ �Ϲ� ����� ������ �ּ����� ���� (����, ������ ����) �ο�
-- // �̰� �� ���ָ� �׽�Ʈ �ܰ迡�� ������ �� ���ٰ� ��
-- [ǥ����] GRANT ����1, ����2... TO ������;
GRANT RESOURCE, CONNECT TO KH;
GRANT CREATE VIEW TO KH;
-- // �����Ϳ� ������ �� �ִ� ���� RESOURCE, ������ �� �ִ� ���� CONNECT, �並 ���� �� �ִ� ���� CREATE VIEW

CREATE USER WK IDENTIFIED BY WK;
GRANT RESOURCE, CONNECT, CREATE VIEW TO WK;

CREATE USER JDBC IDENTIFIED BY JDBC;
GRANT RESOURCE, CONNECT TO JDBC;

CREATE USER LTPROJECT IDENTIFIED BY LTPROJECT;
GRANT RESOURCE, CONNECT, CREATE VIEW TO LTPROJECT;

CREATE USER SERVER IDENTIFIED BY SERVER;
GRANT RESOURCE, CONNECT, CREATE VIEW TO SERVER;

CREATE USER mybatis IDENTIFIED BY mybatis;
GRANT RESOURCE, CONNECT, CREATE VIEW TO mybatis;

CREATE USER spring IDENTIFIED BY spring;
GRANT RESOURCE, CONNECT, CREATE VIEW TO spring;