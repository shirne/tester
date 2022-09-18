import 'package:flutter/material.dart';

import '../widgets/animation_widget.dart';

class AnimationTestPage extends StatefulWidget {
  const AnimationTestPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AnimationTestPage> createState() => _AnimationTestPageState();
}

class _AnimationTestPageState extends State<AnimationTestPage> {
  double damping = 7;
  double mass = 1;
  double stiffness = 70;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('test'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(children: [
          Expanded(
            child: Center(
              child: SpringAnimation(
                description: SpringDescription(
                  damping: damping,
                  mass: mass,
                  stiffness: stiffness,
                ),
                child: const FlutterLogo(size: 200),
              ),
            ),
          ),
          Row(
            children: [
              const Text("damping"),
              Expanded(
                child: Slider(
                  label: "damping",
                  value: damping * 10,
                  max: 100,
                  divisions: 100,
                  onChanged: (nValue) {
                    setState(() {
                      damping = nValue / 10;
                    });
                  },
                ),
              ),
              Text("$damping"),
            ],
          ),
          Row(
            children: [
              const Text("mass"),
              Expanded(
                child: Slider(
                  label: "mass",
                  value: mass * 10,
                  max: 100,
                  divisions: 100,
                  onChanged: (nValue) {
                    setState(() {
                      mass = nValue / 10;
                    });
                  },
                ),
              ),
              Text("$mass"),
            ],
          ),
          Row(
            children: [
              const Text("stiffness"),
              Expanded(
                child: Slider(
                  label: "stiffness",
                  value: stiffness,
                  max: 100,
                  divisions: 100,
                  onChanged: (nValue) {
                    setState(() {
                      stiffness = nValue;
                    });
                  },
                ),
              ),
              Text("$stiffness"),
            ],
          ),
        ]),
      ),
    );
  }
}
