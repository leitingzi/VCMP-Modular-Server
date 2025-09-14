@echo off
:: 设置编码为GB2312
chcp 936 >nul

set "output_file=nutFiles.txt"
setlocal enabledelayedexpansion

:: 获取当前批处理文件所在目录的绝对路径
set "bat_dir=%~dp0"

:: 清空并创建输出文件
echo. > "%output_file%"

:: 搜索所有.nut文件，按创建时间升序排列（ oldest first ）
:: /tc 按创建时间排序 /o-d 降序（最新在前），这里用/tc /on按升序（ oldest first ）
for /f "delims=" %%i in ('dir /s /b /tc /on "*.nut" ^| findstr /v /i "nutFiles.txt" ^| findstr /v /i "loader"') do (
    :: 获取文件的绝对路径
    set "file_path=%%i"
    
    :: 计算相对路径（去除批处理文件目录的前缀）
    set "rel_path=!file_path:%bat_dir%=!"
    
    :: 将路径中的反斜杠\替换为斜杠/
    set "rel_path=!rel_path:\=/!"
    
    :: 写入相对路径到输出文件
    echo !rel_path! >> "%output_file%"
)

endlocal