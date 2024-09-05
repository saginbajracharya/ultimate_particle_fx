import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ultimate_particle_fx/ultimate_particle_fx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultimate Particle FX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ultimate Particle FX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final random = Random();

  // A set to keep track of selected particle shapes
  final Set<ParticleShape> _selectedShapes = {
    ParticleShape.circle,
  };

  // List of all available shapes
  final List<ParticleShape> _allShapes = const [
    ParticleShape.circle,
    ParticleShape.square,
    ParticleShape.triangle,
    ParticleShape.star,
    ParticleShape.hexagon,
    ParticleShape.diamond,
    ParticleShape.pentagon,
    ParticleShape.ellipse,
    ParticleShape.cross,
    ParticleShape.heart,
    ParticleShape.arrow,
    ParticleShape.cloud,
    ParticleShape.octagon,
    ParticleShape.custom
  ];

  // Initial range for min and max size
  RangeValues _particleSizeRange = const RangeValues(5.0, 200.0);

  // Helper method to toggle particle shapes on checkbox change
  void _toggleShape(ParticleShape shape, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedShapes.add(shape);
      } else {
        _selectedShapes.remove(shape);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          UltimateParticleFx(
            neverEnding: true,
            width: MediaQuery.of(context).size.width + 150,
            height: MediaQuery.of(context).size.height + 150,
            velocity: const Offset(0, 0),
            position: const Offset(0, 0),
            colors: const [Colors.green, Colors.yellow, Colors.red, Colors.blue],
            maxSize: _particleSizeRange.end,
            minSize: _particleSizeRange.start,
            lifespan: 1000,
            speed: 0.5,
            maxParticles: 10,
            rotation: 0,
            rotationSpeed: 0.0,
            shapes: _selectedShapes.toList(), // Use selected shapes
            customParticleImage: const [
              AssetImage('assets/images/cloud.png'),
              AssetImage('assets/images/coin.png'),
            ],
            child: const Center(child: Text('')),
          ),
          // DraggableScrollableSheet that contains the customization options
          DraggableScrollableSheet(
            initialChildSize: 0.08, // Initially collapsed
            minChildSize: 0.08, // Minimum height
            maxChildSize: 0.8, // Maximum height when fully expanded
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Icon(
                          Icons.drag_handle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Particle Shape Selection',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      // Checkbox list for shapes
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _allShapes.map((shape) {
                          return CheckboxListTile(
                            title: Text(
                              shape.toString().split('.').last,
                              style: const TextStyle(color: Colors.white),
                            ), // Display shape name
                            value: _selectedShapes.contains(shape),
                            onChanged: (bool? value) {
                              _toggleShape(shape, value ?? false);
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Adjust Particle Size',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      RangeSlider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        values: _particleSizeRange,
                        min: 0.1, // Minimum size for particles
                        max: 300.0, // Maximum size for particles
                        divisions: 100, // Optional, to control steps between values
                        labels: RangeLabels(
                          _particleSizeRange.start.round().toString(),
                          _particleSizeRange.end.round().toString(),
                        ),
                        onChanged: (RangeValues newRange) {
                          setState(() {
                            _particleSizeRange = newRange;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Min Size: ${_particleSizeRange.start.toStringAsFixed(1)}, Max Size: ${_particleSizeRange.end.toStringAsFixed(1)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
