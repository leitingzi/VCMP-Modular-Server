@echo off
:: ���ñ���ΪGB2312
chcp 936 >nul

set "output_file=nutFiles.txt"
setlocal enabledelayedexpansion

:: ��ȡ��ǰ�������ļ�����Ŀ¼�ľ���·��
set "bat_dir=%~dp0"

:: ��ղ���������ļ�
echo. > "%output_file%"

:: ��������.nut�ļ���������ʱ���������У� oldest first ��
:: /tc ������ʱ������ /o-d ����������ǰ����������/tc /on������ oldest first ��
for /f "delims=" %%i in ('dir /s /b /tc /on "*.nut" ^| findstr /v /i "nutFiles.txt" ^| findstr /v /i "loader"') do (
    :: ��ȡ�ļ��ľ���·��
    set "file_path=%%i"
    
    :: �������·����ȥ���������ļ�Ŀ¼��ǰ׺��
    set "rel_path=!file_path:%bat_dir%=!"
    
    :: ��·���еķ�б��\�滻Ϊб��/
    set "rel_path=!rel_path:\=/!"
    
    :: д�����·��������ļ�
    echo !rel_path! >> "%output_file%"
)

endlocal