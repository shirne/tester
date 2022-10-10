#ifndef FLUTTER_PLUGIN_MY_PLUGIN_H_
#define FLUTTER_PLUGIN_MY_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace my_plugin {

class MyPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  MyPlugin();

  virtual ~MyPlugin();

  // Disallow copy and assign.
  MyPlugin(const MyPlugin&) = delete;
  MyPlugin& operator=(const MyPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace my_plugin

#endif  // FLUTTER_PLUGIN_MY_PLUGIN_H_
