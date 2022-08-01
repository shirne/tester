// A simple model class that notifies listeners when it changes.
import 'package:flutter/material.dart';

class Model {
  ValueNotifier<bool> isDirty = ValueNotifier<bool>(false);
  ValueNotifier<int> data = ValueNotifier<int>(0);

  int save() {
    if (isDirty.value) {
      print('Saved Data: ${data.value}');
      isDirty.value = false;
    }
    return data.value;
  }

  void setValue(int newValue) {
    isDirty.value = data.value != newValue;
    data.value = newValue;
  }
}

class ModifyIntent extends Intent {
  const ModifyIntent(this.value);

  final int value;
}

// An Action that modifies the model by setting it to the value that it gets
// from the Intent passed to it when invoked.
class ModifyAction extends Action<ModifyIntent> {
  ModifyAction(this.model);

  final Model model;

  @override
  void invoke(covariant ModifyIntent intent) {
    model.setValue(intent.value);
  }
}

// An intent for saving data.
class SaveIntent extends Intent {
  const SaveIntent();
}

// An Action that saves the data in the model it is created with.
class SaveAction extends Action<SaveIntent> {
  SaveAction(this.model);

  final Model model;

  @override
  int invoke(covariant SaveIntent intent) => model.save();
}

class SaveButton extends StatefulWidget {
  const SaveButton(this.valueNotifier, {Key? key}) : super(key: key);

  final ValueNotifier<bool> valueNotifier;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  int savedValue = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.valueNotifier,
      builder: (BuildContext context, Widget? child) {
        return TextButton.icon(
          icon: const Icon(Icons.save),
          label: Text('$savedValue'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              widget.valueNotifier.value ? Colors.red : Colors.green,
            ),
          ),
          onPressed: () {
            setState(() {
              savedValue = Actions.invoke(context, const SaveIntent())! as int;
            });
          },
        );
      },
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class ActionTestWidget extends StatefulWidget {
  const ActionTestWidget({Key? key}) : super(key: key);

  @override
  State<ActionTestWidget> createState() => _ActionTestWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ActionTestWidgetState extends State<ActionTestWidget> {
  Model model = Model();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Actions(
          actions: <Type, Action<Intent>>{
            ModifyIntent: ModifyAction(model),
            SaveIntent: SaveAction(model),
          },
          child: Builder(
            builder: (BuildContext context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.exposure_plus_1),
                        onPressed: () {
                          Actions.invoke(context, ModifyIntent(++count));
                        },
                      ),
                      AnimatedBuilder(
                          animation: model.data,
                          builder: (BuildContext context, Widget? child) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${model.data.value}',
                                  style: Theme.of(context).textTheme.headline4),
                            );
                          }),
                      IconButton(
                        icon: const Icon(Icons.exposure_minus_1),
                        onPressed: () {
                          Actions.invoke(context, ModifyIntent(--count));
                        },
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('test button'),
                        style: OutlinedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('test button'),
                        style: OutlinedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          shape: const ContinuousRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('test button'),
                        style: OutlinedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('test button'),
                        style: OutlinedButton.styleFrom(
                          primary: Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ],
                  ),
                  SaveButton(model.isDirty),
                  const Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
