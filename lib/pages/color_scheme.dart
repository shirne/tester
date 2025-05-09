import 'package:flutest/utils/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

class ColorSchemePage extends StatefulWidget {
  const ColorSchemePage({super.key});

  @override
  State<ColorSchemePage> createState() => _ColorSchemePageState();
}

class _ColorSchemePageState extends State<ColorSchemePage> {
  var schemeVariant = DynamicSchemeVariant.tonalSpot;
  var color = Colors.blue.shade500;
  var brightness = Brightness.light;

  late var colorScheme = ColorScheme.fromSeed(seedColor: color);

  void updateScheme() {
    setState(() {
      colorScheme = ColorScheme.fromSeed(
        seedColor: color,
        dynamicSchemeVariant: schemeVariant,
        brightness: brightness,
      );
    });
  }

  Widget card(
    String title,
    Color background,
    Color foreground, [
    Widget? plus,
  ]) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: () {
            MyDialog.alert(Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: background.toHex()));
                    MyDialog.toast('已复制到剪贴板');
                  },
                  child: Text('Background: ${background.toHex()}'),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: foreground.toHex()));
                    MyDialog.toast('已复制到剪贴板');
                  },
                  child: Text('Foreground: ${foreground.toHex()}'),
                ),
              ],
            ));
          },
          child: Container(
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                FittedBox(
                  child: Text(
                    title,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 16,
                      color: foreground,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '此处使用的颜色 (${foreground.toHex()}/${background.toHex()})',
                      style: TextStyle(
                        fontSize: 12,
                        color: foreground,
                      ),
                    ),
                  ),
                ),
                if (plus != null) FittedBox(child: plus),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Scheme'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Brightness'),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showCupertinoSheet(
                          context: context,
                          pageBuilder: (context) {
                            return CupertinoActionSheet(
                              actions: [
                                for (var dsv in Brightness.values)
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        brightness = dsv;
                                      });
                                      updateScheme();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(dsv.name),
                                  ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('取消'),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(brightness.name),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('DynamicSchemeVariant'),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showCupertinoSheet(
                          context: context,
                          pageBuilder: (context) {
                            return CupertinoActionSheet(
                              actions: [
                                for (var dsv in DynamicSchemeVariant.values)
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        schemeVariant = dsv;
                                      });
                                      updateScheme();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(dsv.name),
                                  ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('取消'),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(schemeVariant.name),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Seed Color'),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        var currentColor = ValueNotifier(color);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Pick a color!'),
                              content: SingleChildScrollView(
                                child: ValueListenableBuilder<Color>(
                                    valueListenable: currentColor,
                                    builder: (context, color, child) {
                                      return ColorPicker(
                                        pickerColor: color,
                                        onColorChanged: (color) {
                                          currentColor.value = color;
                                        },
                                      );
                                    }),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('取消'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() => color = currentColor.value);
                                    updateScheme();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('确定'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(color.toRgb()),
                          SizedBox(width: 8),
                          Text(color.toHex()),
                          SizedBox(width: 8),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: card(
                      'primary',
                      colorScheme.primary,
                      colorScheme.onPrimary,
                    ),
                  ),
                  Expanded(
                    child: card(
                      'secondary',
                      colorScheme.secondary,
                      colorScheme.onSecondary,
                    ),
                  ),
                  Expanded(
                    child: card(
                      'tertiary',
                      colorScheme.tertiary,
                      colorScheme.onTertiary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: card(
                      'primaryContainer',
                      colorScheme.primaryContainer,
                      colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Expanded(
                    child: card(
                      'secondaryContainer',
                      colorScheme.secondaryContainer,
                      colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Expanded(
                    child: card(
                      'tertiaryContainer',
                      colorScheme.tertiaryContainer,
                      colorScheme.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: card(
                      'primaryFixed',
                      colorScheme.primaryFixed,
                      colorScheme.onPrimaryFixed,
                      Text(
                        'onPrimaryFixedVariant',
                        softWrap: false,
                        style: TextStyle(
                          backgroundColor: colorScheme.primaryFixedDim,
                          color: colorScheme.onPrimaryFixedVariant,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: card(
                      'secondaryFixed',
                      colorScheme.secondaryFixed,
                      colorScheme.onSecondaryFixed,
                      Text(
                        'onSecondaryFixedVariant',
                        softWrap: false,
                        style: TextStyle(
                          backgroundColor: colorScheme.secondaryFixedDim,
                          color: colorScheme.onSecondaryFixedVariant,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: card(
                      'tertiaryFixed',
                      colorScheme.tertiaryFixed,
                      colorScheme.onTertiaryFixed,
                      Text(
                        'onTertiaryFixedVariant',
                        softWrap: false,
                        style: TextStyle(
                          backgroundColor: colorScheme.tertiaryFixedDim,
                          color: colorScheme.onTertiaryFixedVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: card(
                      'onError',
                      colorScheme.onError,
                      colorScheme.error,
                    ),
                  ),
                  Expanded(
                    child: card(
                      'errorContainer',
                      colorScheme.errorContainer,
                      colorScheme.onErrorContainer,
                    ),
                  ),
                  Expanded(
                    child: card(
                      'surface/outline',
                      colorScheme.surface,
                      colorScheme.outline,
                      Text(
                        'outlineVariant',
                        softWrap: false,
                        style: TextStyle(
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: card(
                      'surface',
                      colorScheme.surface,
                      colorScheme.onSurface,
                      Text(
                        'onSurfaceVariant',
                        softWrap: false,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: card(
                      'surfaceDim',
                      colorScheme.surfaceDim,
                      colorScheme.onSurface,
                      Text(
                        'onSurfaceVariant',
                        softWrap: false,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: card(
                      'surfaceBright',
                      colorScheme.surfaceBright,
                      colorScheme.onSurface,
                      Text(
                        'onSurfaceVariant',
                        softWrap: false,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: card(
                      'inverseSurface',
                      colorScheme.inverseSurface,
                      colorScheme.onInverseSurface,
                      Text(
                        'inversePrimary',
                        softWrap: false,
                        style: TextStyle(
                          color: colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: card(
                      'surfaceContainerLowest',
                      colorScheme.surfaceContainerLowest,
                      colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: card(
                      'surfaceContainerLow',
                      colorScheme.surfaceContainerLow,
                      colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: card(
                      'surfaceContainer',
                      colorScheme.surfaceContainer,
                      colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: card(
                      'surfaceContainerHigh',
                      colorScheme.surfaceContainerHigh,
                      colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: card(
                      'surfaceContainerHighest',
                      colorScheme.surfaceContainerHighest,
                      colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
