@echo off
:: ���ñ���ΪGB2312����ȷ������������
chcp 936 >nul

set "output_file=allnut.nut"
setlocal enabledelayedexpansion

:: ��ȡ��ǰ�������ļ�����Ŀ¼�ľ���·��
set "current_dir=%~dp0"

:: �������ļ�����������򸲸ǣ�
echo. > "%output_file%"

echo ������������.nut�ļ����ϲ�����...

:: �ݹ�������ǰĿ¼����Ŀ¼�е�����.nut�ļ�
for /r %%f in (*.nut) do (
    :: �ų�����ļ���������ݹ����
    if /i not "%%~nxf"=="%output_file%" (
        :: ��ȡ�ļ��ľ���·��
        set "full_path=%%~f"
        :: �������·����ȥ����ǰĿ¼��ǰ׺��
        set "rel_path=!full_path:%current_dir%=!"
        
        echo ���ڴ���: !rel_path!
        :: д�����·����Ϊ�ָ���ʶ
        echo. >> "%output_file%"
        echo // ------------ ������ !rel_path! ������ ------------ >> "%output_file%"
        echo. >> "%output_file%"
        :: ׷���ļ����ݵ�����ļ�
        type "%%f" >> "%output_file%"
        echo. >> "%output_file%"
        echo // ------------ !rel_path! ���ݽ��� ------------ >> "%output_file%"
        echo. >> "%output_file%"
    )
)

endlocal

echo ����.nut�ļ������Ѻϲ��� %output_file%
:: �ȴ�2����Զ��رմ��ڣ�����鿴���
timeout /t 2 /nobreak >nul
exit
    