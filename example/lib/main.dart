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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: UltimateParticleFx(
        neverEnding: true,
        width: MediaQuery.of(context).size.width+150,
        height: MediaQuery.of(context).size.height+150,
        velocity: const Offset(0, 0),
        position: const Offset(0, 0),
        colors : const [Colors.green,Colors.yellow,Colors.red,Colors.blue],
        maxSize: 200.0,
        minSize: 5.0,
        lifespan: 1000,
        speed: 0.5,
        maxParticles: 10,
        rotation: random.nextDouble()*50.0,
        rotationSpeed: 0.0,
        shapes: const [
          // ParticleShape.circle, 
          // ParticleShape.square, 
          // ParticleShape.triangle,
          // ParticleShape.star,
          // ParticleShape.hexagon,
          // ParticleShape.diamond,
          // ParticleShape.pentagon,
          // ParticleShape.ellipse,
          // ParticleShape.cross,
          // ParticleShape.heart,
          // ParticleShape.arrow,
          // ParticleShape.cloud,
          // ParticleShape.octagon,
          ParticleShape.custom
        ],
        customParticleImage: const [
          // NetworkImage('https://p1.hiclipart.com/preview/193/496/988/flappy-bird-sprite-flappy-bird-blue-video-games-flying-flappy-android-mobile-game-pixel-art-dong-nguyen-png-clipart-thumbnail.jpg'),
          NetworkImage('https://www.vhv.rs/dpng/d/397-3976228_wispy-clouds-sprite-cloud-sprite-hd-png-download.png'),
        ],
        child: const Center(
          child: Text('Ultimate Particle FX')
        )
      )
    );
  }
}
