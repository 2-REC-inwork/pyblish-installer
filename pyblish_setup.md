# PYBLISH

(TODO: add description)

https://github.com/pyblish


## Setup

### ...

(TODO: rewrite)
- Windows 10 (64 bits)

- Considering project directory:
%USERPROFILE%\Documents\pyblish

The variable "PYBLISH_PATH" will be used to identify the location of the project.


### Pyblish Base

Core library.

Download/clone from:
https://github.com/pyblish/pyblish-base

Extract/copy to:
%PYBLISH_PATH%\src\pyblish-base

The variable "PYBLISH_BASE_PATH" will be used to identify the location of 'pyblish-base'.


### Pyblish QML

UI module (for standalone or in DCC).

Download/clone from:
https://github.com/pyblish/pyblish-qml

Extract/copy to:
%PYBLISH_PATH%\src\pyblish-qml

The variable "PYBLISH_QML_PATH" will be used to identify the location of 'pyblish-qml'.


### Pyblish Maya

Integration in Maya and example plugins.

Download/clone from:
https://github.com/pyblish/pyblish-maya

Extract/copy to:
%PYBLISH_PATH%\src\pyblish-maya

The variable "PYBLISH_MAYA_PATH" will be used to identify the location of 'pyblish-maya'.


### Others Pyblish modules

Other modules are available for other DCCs (Houdini, Nuke, etc.).
(follow same process as for 'pyblish-maya')
!!!! TODO !!!!


### Python

Pyblish can be used with Python 2 or 3.


#### Python 2.7

(TODO: Python 2.7 - 32/64?)


#### Python 3.7.9

Download from:
https://www.python.org/downloads/release/python-379/
Using the 64 bits version, but the process is the same with the 32 bits version.

Install:
It is not required to have a system wide installation: a portable installation (extraction) can be used.

Default installation path:
%USERPROFILE%\AppData\Local\Programs\Python\Python37

The variable "PYTHON_INSTALL_PATH" will be used to identify the location of Python installation.


### PyQt5

(TODO: or PySide2? - Haven't tried)

! - with Python 3.7:
In the [Pyblish QML documentation](https://github.com/pyblish/pyblish-qml/wiki/Python-3.5-Any-Platform) it is mentionned to try version 5.8 with Python 3.7, however the installation using PIP seems to be broken: the 'sip' module isn't installed properly.
=> Using the latest PyQt5 (currently '5.15.4') seems to work correctly.

The PyQt5 package and its dependencies can be downloaded and installed directly with 'pip'.
However, for easier portability, it can be done in 2 separate steps.
This will allow to install Pyblish on machines with no Internet access.

Download:
This must obviously be done on a machine with Internet access and with Python installed*.
```bat
python -m pip download -d <DOWNLOAD_PATH> PyQt5
```
Where "<DOWNLOAD_PATH>" is the directory where to download the packages.

If 'python.exe' is not in PATH, use the full path instead of 'python'.
E.g.:
  "%USERPROFILE%\AppData\Local\Programs\Python\Python37\python.exe"


Install:
This can be done on a machine with no Internet access and with Python installed*.
```bat
python -m pip install --no-index --find-links <DOWNLOAD_PATH> PyQt5
```
Where "<DOWNLOAD_PATH>" is the directory where the downloaded packages are stored.


*It is important that the Python versions used for the download and for the installation are the same, to avoid any incompatibility issues - especially regarding 32 and 64 bits.


---

## Usage

### Standalone

...
(TODO)


### Maya

#### Environment

Tested on Maya 2020.
(TODO: test all versions 2018-2022)
- 2019: OK
- 2020: OK
- 2022: NOT OK! (problem in 'init_pyblish' script - due to Python 2?)
  ? => Could add 'python version' variable in env when using Maya 2022 (?)


(TODO: rewrite)
Maya needs to be started in a specific environment to be able to use Pyblish.


The following script can be used to set the environment and start Maya:
(TODO: add details about variables to define)
```bat
REM - Paths setup
set PYBLISH_PATH=%USERPROFILE%\Documents\pyblish
set MAYA_PATH=C:\Program Files\Autodesk\Maya2020
set PYTHON_INSTALL_PATH=%USERPROFILE%\AppData\Local\Programs\Python\Python37

set PYBLISH_BASE_PATH=%PYBLISH_PATH%\src\pyblish-base
set PYBLISH_QML_PATH=%PYBLISH_PATH%\src\pyblish-qml

REM - Pyblish paths
set PYTHONPATH=%PYBLISH_BASE_PATH%;%PYBLISH_QML_PATH%;%PYTHONPATH%
set PYBLISH_QML_PYTHON_EXECUTABLE=%PYTHON_INSTALL_PATH%\python.exe
REM - doesn't seem needed
REM set PYBLISH_QML_PYQT5=...

start "Maya - Pyblish" /b "%MAYA_PATH%\bin\maya.exe"
```

The following varaibles are required by Maya and Pyblish:
- 'PYTHONPATH': List of paths where Python code is located (all the Pyblish modules)
- 'PYBLISH_QML_PYTHON_EXECUTABLE': Location of the Python executable used to execute Pyblish*

*Alternatively to 'PYBLISH_QML_PYTHON_EXECUTABLE', the pat to Python executable can be set in the code:
```python
from pyblish_qml import api
api.register_python_executable(path_to_python)
```
where 'path_to_python' is the path to the Python executable (e.g.: "C:/Python27/python.exe").


#### Pyblish Launcher

(TODO: rewrite)
Basic usage in Maya using the Python Script Editor:
```python
from pyblish import api
from pyblish_qml import show

# Register Maya
api.register_host("maya")

show()
```

The command:
```python
api.register_host("maya")
```
isn't necessarily required, but can be used to specify the ['host'](TODO: 'hosts') for the plugins.

Better alternatives are to create commands:
- in a shelf (TODO: link to section 'Command in Shelf')
- in a menu (TODO: link to section 'Command in Menu') - TODO: better section name!


##### Command in Shelf

For ease of use, the Pyblish command can be added to a shelf.

The following is required:
- The command code (as previously):
    ```python
    from pyblish import api
    from pyblish_qml import show

    # Register Maya
    api.register_host("maya")

    show()
    ```
- The command icon:
    The Pyblish icon can be found in the 'icons' directory of Pyblish ("%PYBLISH_BASE_PATH%\pyblish\icons").

To avoid creating the command manually and locally, look at (TODO: ADD LINK TO SECTION ...!).


##### Command in Menu

The Pyblish command can also be added to a menu.

The helper functions provided by 'pyblish-maya' allow to easily integrate Pyblish in Maya:
```python
from pyblish import api
import pyblish_maya

# Register Maya and plugins
api.register_gui("pyblish_qml")
pyblish_maya.setup()
```

These commands will register Maya in Pyblish as well as its Pyblish plugins (provided in the 'plugins' directory of 'pyblish-maya'*), and add the Pyblish command to the 'File' menu.
It will also register 'pyblish-qml' as the GUI to be used.


*NOTE:
The 'plugins' directory must exist in 'pyblish-maya', even if using other plugins locations.
It can be empty, as long as it contains the '__init__.py' file.
Alternatively, an empty 'plugins.py' file can be created and the directory removed.



The path to 'pyblish-maya' must be added to 'PYTHONPATH' as set by the command (to be added to the environment):
```bat
set PYTHONPATH=%PYBLISH_PATH%\src\pyblish-maya;%PYTHONPATH%
```


This code needs to be run at Maya startup, while the menus are being created. The script should thus be run when launching Maya.
It can be provided as a parameter to the command line:
```bat
start "Maya - Pyblish" /b "%MAYA_PATH%\bin\maya.exe" -command "python(\"import init_pyblish\");"
```
where 'init_pyblish.py' is a Python script containing the initialisation code.
The script must be located in a directory defined in 'PYTHONPATH'.
Example:
```bat
set PYTHONPATH=%PYBLISH_PATH%\maya\scripts;%PYTHONPATH%
```

When starting Maya (with the environment set up as well), the "Publish" command should be available in the 'File' menu.
The plgins provided with 'pyblish-maya' should also be available in Pyblish.


---

## Plugins

(not maya specific)


### Paths

To add a plugin path to Pyblish, use the following command:
```python
pyblish.plugin.register_plugin_path("<PATH_TO_PLUGINS>")
```
where "<PATH_TO_PLUGINS>" is the path containing the plugins.

More than 1 path can be added, by calling repeatedly the command.
(TOSO: rewrite)
If have 'common' plugins, and application specific ones, it is advised to register the application paths first, so that if duplicate plugins, the application specific ones are kept.


The following example shows how to register muliple plugin paths defined in the environment variable "PYBLISH_PLUGINS_PATHS":
```python
import os
from pyblish import plugin

# Register plugin paths
plugin_paths = os.getenv("PYBLISH_PLUGINS_PATHS")
if plugin_paths:
    #TODO: make cross OS compatible
    plugin_paths = plugin_paths.split(";")
    for plugin_path in plugin_paths:
        if not os.path.isdir(plugin_path):
            continue
        plugin.register_plugin_path(plugin_path)
```

The environment could have the variable defined as:
```bat
set PYBLISH_PLUGINS_PATHS=%PYBLISH_PATH%\plugins\maya;%PYBLISH_PATH%\plugins
```


### Hosts

Each plugin can specify if it is specific to 1 or more DCCs by specifying its 'hosts'. If no hosts are specified, the plugin is common to all applications (as well as standalone Pyblish).

To be able to use the plugins aimed at a specific host, an application needs to register as the host.

The registration is done using the 'register_host' command, as in the following example for Maya:
```python
from pyblish import api
api.register_host("maya")
```
Alternatively, helper functions provided by other modules (such as 'pyblish-maya') can be used:
```python
import pyblish_maya
pyblish_maya.setup()
````

---

## Wrapping Up

=> Wrapping everything together.


Content of the "%PYBLISH_PATH%" directory:

* [maya]
  * start_maya.bat
  * [scripts]
    * init_pyblish.py
  * [shelves]
    * shelf_Pyblish.mel
* [plugins]
  * [maya]
    * (Maya plugins)
  * (common plugins)



