@echo off



echo TODO!
(=> look at "TODO/setup_pyblish.bat")

Auto setup script:
- extract python
- install pyqt5 (pip)
- extract pyblish-base
  ? => should delete content of "plugins" directory (except __init__.py)
- extract pyblish-qml
- extract pyblish-maya
  ? => should delete content of "plugins" directory (except __init__.py)
- copy scripts (bat, py, shelf)
- add "pth" file (=> in Python root dir, with a line for each module path)
  ! => DON'T use a name that exist as a module (eg: "pyblish"!) => can use "pyblish_paths.pth"
- plugins?
  => should use shared network directory
- shortcut?





pause
exit /b