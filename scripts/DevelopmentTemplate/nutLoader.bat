@echo off
:: 设置编码为GB2312�?65001是UTF-8�?936是GB2312�?
chcp 936 >nul

set "output_file=nutFiles.txt"
setlocal enabledelayedexpansion

:: 获取当前批�?�理文件所在目录的绝�?�路�?
set "bat_dir=%~dp0"

:: 清空并创建输出文件（若已存在则�?�盖�?
echo. > "%output_file%"

:: 搜索当前�?录及子目录下所�? .nut 文件，排�?nutFiles.txt和名字中带有loader的文件，
:: 并将相�?�路径写�?nutFiles.txt（使�?/分隔�?
for /r %%i in (*.nut) do (
    :: 检查当前文件是否为nutFiles.txt或文件名�?包含loader
    if /i not "%%~nxi"=="nutFiles.txt" (
        echo "%%~nxi" | findstr /i "loader" >nul
        if errorlevel 1 (
            :: 获取文件的绝对路�?
            set "file_path=%%~fi"
            
            :: 计算相�?�路径（去除批�?�理文件�?录的前缀�?
            set "rel_path=!file_path:%bat_dir%=!"
            
            :: 将路径中的反斜杠\替换为斜�?/
            set "rel_path=!rel_path:\=/!"
            
            :: 写入相�?�路径到输出文件（不添加双引号）
            echo !rel_path! >> "%output_file%"
        )
    )
)