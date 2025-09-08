@echo off
:: 设置编码为GB2312（65001是UTF-8，936是GB2312）
chcp 936 >nul

set "output_file=nutFiles.nut"
setlocal enabledelayedexpansion

:: 获取当前批处理文件所在目录的绝对路径
set "bat_dir=%~dp0"

:: 清空并创建输出文件（若已存在则覆盖）
echo. > "%output_file%"

:: 搜索当前目录及子目录下所有 .nut 文件，排除nutFiles.nut，并将相对路径写入 loader.nut（使用/分隔）
for /r %%i in (*.nut) do (
    :: 检查当前文件是否为nutFiles.nut
    if /i not "%%~nxi"=="nutFiles.nut" (
        :: 获取文件的绝对路径
        set "file_path=%%~fi"
        
        :: 计算相对路径（去除批处理文件目录的前缀）
        set "rel_path=!file_path:%bat_dir%=!"
        
        :: 将路径中的反斜杠\替换为斜杠/
        set "rel_path=!rel_path:\=/!"
        
        :: 写入相对路径到输出文件（不添加双引号）
        echo !rel_path! >> "%output_file%"
    )
)
    