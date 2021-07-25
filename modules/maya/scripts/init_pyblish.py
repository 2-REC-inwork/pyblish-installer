import os
import logging

from pyblish import api, plugin
import pyblish_maya

log = logging.getLogger()


# Register plugin paths
plugin_paths = os.getenv("PYBLISH_PLUGINS_PATHS")
if plugin_paths:
    #TODO: make cross OS compatible
    plugin_paths = plugin_paths.split(";")
    for plugin_path in plugin_paths:
        if not os.path.isdir(plugin_path):
            log.warning("Invalid plugin path: %s" % plugin_path)
            continue

        log.debug("Registering path: %s" % plugin_path)
        plugin.register_plugin_path(plugin_path)


# Register Maya
api.register_gui("pyblish_qml")
pyblish_maya.setup()
