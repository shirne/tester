#include "include/my_plugin/my_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "my_plugin.h"

void MyPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  my_plugin::MyPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
