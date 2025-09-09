@echo off
:: 设置编码为GB2312以正确处理中文内容
chcp 936 >nul

set "output_file=allnut.nut"
setlocal enabledelayedexpansion

:: 获取当前批处理文件所在目录的绝对路径
set "current_dir=%~dp0"

:: 清空输出文件（如果存在则覆盖）
echo. > "%output_file%"

echo 正在搜索所有.nut文件并合并内容...

:: 递归搜索当前目录及子目录中的所有.nut文件
for /r %%f in (*.nut) do (
    :: 排除输出文件本身，避免递归包含
    if /i not "%%~nxf"=="%output_file%" (
        :: 获取文件的绝对路径
        set "full_path=%%~f"
        :: 计算相对路径（去除当前目录的前缀）
        set "rel_path=!full_path:%current_dir%=!"
        
        echo 正在处理: !rel_path!
        :: 写入相对路径作为分隔标识
        echo. >> "%output_file%"
        echo // ------------ 以下是 !rel_path! 的内容 ------------ >> "%output_file%"
        echo. >> "%output_file%"
        :: 追加文件内容到输出文件
        type "%%f" >> "%output_file%"
        echo. >> "%output_file%"
        echo // ------------ !rel_path! 内容结束 ------------ >> "%output_file%"
        echo. >> "%output_file%"
    )
)

endlocal

echo 所有.nut文件内容已合并到 %output_file%
:: 等待2秒后自动关闭窗口，方便查看结果
timeout /t 2 /nobreak >nul
exit
    