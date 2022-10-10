//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <my_plugin/my_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) my_plugin_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MyPlugin");
  my_plugin_register_with_registrar(my_plugin_registrar);
}
