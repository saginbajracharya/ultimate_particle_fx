import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ultimate_particle_fx/particles_enum/movement_direction.dart';
import 'package:ultimate_particle_fx/particles_enum/particle_shapes.dart';
import 'package:ultimate_particle_fx/particles_enum/spawn_position.dart';
import 'package:ultimate_particle_fx/particles_enum/touch_type.dart';
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
    ParticleShape.heart,
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
  RangeValues _particleSizeRange = const RangeValues(5.0, 10.0);
  SpawnPosition _spawnPosition = SpawnPosition.random;
  MovementDirection _movementDirection = MovementDirection.random;
  double _spawnWidth = 300;
  double _spawnHeight = 600;
  double _velocityX = 0;
  double _velocityY = 0;
  double lifespan = 500;
  double speed = 0.01;
  int initialParticles = 1;
  int maxParticles = 20;
  double rotation = 0;
  TouchType touchtype = TouchType.swirl;
  bool neverEnding = true;
  bool allowParticlesExitSpawnArea = true;

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
        alignment: Alignment.center,
        children: [
          UltimateParticleFx(
            neverEnding: neverEnding,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            velocity: Offset(_velocityX, _velocityY),
            position: const Offset(0, 0),
            colors: const [Colors.green, Colors.yellow, Colors.red, Colors.blue,Colors.white],
            // gradient: const LinearGradient(
            //   colors: [Colors.orange,Colors.red],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   stops: [0.0, 1.0]
            // ),
            maxSize: _particleSizeRange.end,
            minSize: _particleSizeRange.start,
            lifespan: lifespan,
            speed: speed,
            initialParticles: initialParticles,
            maxParticles: maxParticles,
            rotation: rotation,
            shapes: _selectedShapes.toList(),
            customParticleImage: const [
              AssetImage('assets/images/cloud.png'),
              AssetImage('assets/images/coin.png'),
            ],
            allowParticlesExitSpawnArea : allowParticlesExitSpawnArea,
            spawnPosition : _spawnPosition,
            movementDirection : _movementDirection,
            spawnAreaPosition: Offset(
              (MediaQuery.of(context).size.width / 2) - (_spawnWidth / 2),  // Horizontal center
              (MediaQuery.of(context).size.height / 2) - (_spawnHeight / 2), // Vertical center
            ),
            spawnAreaWidth : _spawnWidth,
            spawnAreaHeight : _spawnHeight,
            spawnAreaColor: Colors.white.withOpacity(0.1),
            touchType: touchtype,
            child: const Center(child: Text('')),
          ),
          // DraggableScrollableSheet that contains the customization options
          DraggableScrollableSheet(
            initialChildSize: 0.08, // Initially collapsed
            minChildSize: 0.08, // Minimum height
            maxChildSize: 0.3, // Maximum height when fully expanded
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
                      // Add Switch for neverEnding
                      const Text('Never Ending', style: TextStyle(color: Colors.white, fontSize: 18)),
                      Switch(
                        value: neverEnding,
                        activeColor: Colors.white,
                        inactiveThumbColor: Colors.grey,
                        onChanged: (bool value) {
                          setState(() {
                            neverEnding = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Add Switch for allowParticlesExitSpawnArea
                      const Text('Allow Particles to Exit Spawn Area', style: TextStyle(color: Colors.white, fontSize: 18)),
                      Switch(
                        value: allowParticlesExitSpawnArea,
                        activeColor: Colors.white,
                        inactiveThumbColor: Colors.grey,
                        onChanged: (bool value) {
                          setState(() {
                            allowParticlesExitSpawnArea = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Touch Type
                      const Text(
                        'Touch Type',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      DropdownButton<TouchType>(
                        dropdownColor: Colors.black,
                        value: touchtype,
                        items: TouchType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(
                              type.toString().split('.').last,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (TouchType? newValue) {
                          setState(() {
                            touchtype = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Particle Shape Selection
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
                      // Spawn Position
                      const Text(
                        'Spawn Position',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      DropdownButton<SpawnPosition>(
                        dropdownColor: Colors.black,
                        value: _spawnPosition,
                        items: SpawnPosition.values.map((position) {
                          return DropdownMenuItem(
                            value: position,
                            child: Text(
                              position.toString().split('.').last,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (SpawnPosition? newValue) {
                          setState(() {
                            _spawnPosition = newValue ?? _spawnPosition;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Movement Direction
                      const Text(
                        'Movement Direction',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      DropdownButton<MovementDirection>(
                        dropdownColor: Colors.black,
                        value: _movementDirection,
                        items: MovementDirection.values.map((direction) {
                          return DropdownMenuItem(
                            value: direction,
                            child: Text(
                              direction.toString().split('.').last,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (MovementDirection? newValue) {
                          setState(() {
                            _movementDirection = newValue ?? _movementDirection;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Adjust Spawn Width
                      const Text(
                        'Adjust Spawn Width',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        value: _spawnWidth,
                        min: 0,
                        max: MediaQuery.of(context).size.width,
                        divisions: 100,
                        label: _spawnWidth.toStringAsFixed(1),
                        onChanged: (double newValue) {
                          setState(() {
                            _spawnWidth = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Adjust Spawn Height
                      const Text(
                        'Adjust Spawn Height',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        value: _spawnHeight,
                        min: 0,
                        max: MediaQuery.of(context).size.height,
                        divisions: 100,
                        label: _spawnHeight.toStringAsFixed(1),
                        onChanged: (double newValue) {
                          setState(() {
                            _spawnHeight = newValue;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Spawn Width: ${_spawnWidth.toStringAsFixed(1)}, Spawn Height: ${_spawnHeight.toStringAsFixed(1)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Adjust Particle Size
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
                      const SizedBox(height: 20),
                      // Velocity X
                      const Text(
                        'Adjust Velocity X',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        value: _velocityX,
                        min: -50.0,
                        max: 50.0,
                        divisions: 100,
                        label: _velocityX.toStringAsFixed(1),
                        onChanged: (double newValue) {
                          setState(() {
                            _velocityX = newValue;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Velocity X : ${_velocityX.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Velocity Y
                      const Text(
                        'Adjust Velocity Y',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        value: _velocityY,
                        min: -50.0,
                        max: 50.0,
                        divisions: 100,
                        label: _velocityY.toStringAsFixed(1),
                        onChanged: (double newValue) {
                          setState(() {
                            _velocityY = newValue;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Velocity Y : ${_velocityY.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Lifespan
                      const Text(
                        'Lifespan',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        value: lifespan, // Adjust lifespan value
                        min: 10,
                        max: 99000,
                        onChanged: (double value) {
                          setState(() {
                            // Update lifespan
                            lifespan = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Lifespan : ${lifespan.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Speed
                      const Text(
                        'Speed',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        value: speed, // Speed value
                        min: 0.01,
                        max: 10.0,
                        onChanged: (double value) {
                          setState(() {
                            // Update speed value
                            speed = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Speed : ${speed.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Initial Particles
                      const Text(
                        'Initial Particles',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        value: initialParticles.toDouble(), // Initial particles
                        min: 0,
                        max: 100,
                        onChanged: (double value) {
                          setState(() {
                            // Update initial particles value
                            initialParticles = value.toInt();
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Iniial Particles : ${initialParticles.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Max Particles
                      const Text(
                        'Max Particles',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        value: maxParticles.toDouble(), // Max particles
                        min: 1,
                        max: 1000,
                        onChanged: (double value) {
                          setState(() {
                            // Update max particles value
                            maxParticles = value.toInt();
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Max Particles : ${maxParticles.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Rotation
                      const Text(
                        'Rotation',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        value: rotation, // Rotation
                        min: -360,
                        max: 360,
                        onChanged: (double value) {
                          setState(() {
                            // Update rotation value
                            rotation = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Rotation : ${rotation.toStringAsFixed(2)}',
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
