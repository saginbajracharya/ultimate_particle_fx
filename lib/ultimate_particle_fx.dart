library ultimate_particle_fx;
import 'package:flutter/material.dart';

class UltimateParticleFx extends StatefulWidget {
  const UltimateParticleFx({
    super.key,
  });

  @override
  UltimateParticleFxState createState() => UltimateParticleFxState();
}

class UltimateParticleFxState extends State<UltimateParticleFx> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget (UltimateParticleFx oldWidget) {
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}