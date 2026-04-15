@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0canon_ydwe_chain_probe.ps1" %*
