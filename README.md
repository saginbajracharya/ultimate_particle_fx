# Ultimate Particle FX

Ultimate Particle FX is a customizable Particle Effects for your Flutter Applications.

## How To Use

Ultimate Particle FX can be used simply as a widget

Add this to your package's pubspec.yaml file, use the latest version

```yaml
dependencies:
  ultimate_particle_fx: ^latest_version
```

```dart
import 'package:ultimate_particle_fx/ultimate_particle_fx.dart';
  
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
        maxParticles: 10,
        speed: 0.5,
        rotation: 0,
        shapes: const [
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
        ],
        customParticleImage: const [
          AssetImage('assets/images/cloud.png'),
          AssetImage('assets/images/coin.png'),
          NetworkImage('https://www.vhv.rs/dpng/d/397-3976228_wispy-clouds-sprite-cloud-sprite-hd-png-download.png'),
        ],
        gradient: const LinearGradient(
          colors: [Colors.orange,Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0]
        ),
        allowParticlesExitSpawnArea : true,
        spawnAreaPosition : const Offset(0, 0),
        spawnPosition : SpawnPosition.random,
        movementDirection : MovementDirection.random,
        spawnAreaWidth : double.infinity,
        spawnAreaHeight : double.infinity, 
        spawnAreaColor : Colors.transparent,
        touchType: TouchType.push,
        child: const Center(
          child: Text('Ultimate Particle FX')
        )
      )
    );
  }
```

## Properties

| Property                         | Description                                                                     |
|----------------------------------|---------------------------------------------------------------------------------|
| neverEnding                      | NeverEnding or Ending type of Effect                                            |
| width                            | Width of A Particles Container                                                  |
| height                           | Height of A Particles Container                                                 |
| position                         | Position OffSet                                                                 |
| velocity                         | Velocity Offset                                                                 |
| colors                           | List of Colors For A Particle                                                   |
| minSize                          | Minimum Size of A Particle                                                      |
| maxSize                          | Maximum Size of A Particle                                                      |
| lifespan                         | LifeSpan of A Particle                                                          |
| maxParticles                     | Maximum no of Particles                                                         |
| speed                            | Speed of Animation                                                              |
| shapes                           | Shapes                                                                          |
| customParticleImage              | Custom Image For A Particle                                                     |
| rotation                         | rotation                                                                        |
| gradient                         | gradient for shapes [Note: Gradient is priority if given else color]            |
| allowParticlesExitSpawnArea      | Bool Allow or Not Allow Particles to exit the given spawn width height bound    |
| spawnAreaPosition                | Position of Spawn Area Offset(dx,dy)                                            |
| spawnPosition                    | Particle Spawn Position within the spawnAreaPosition                            |
| movementDirection                | Movement Direction of the particles after emission                              |
| spawnAreaWidth                   | Width for Spawn Area                                                            |
| spawnAreaHeight                  | Height for Spawn Area                                                           |
| spawnAreaColor                   | Color for Spawn Area                                                            |
| touchType                        | On Touch particle effects                                                       |
| child                            | Child as a Widget                                                               |

## Check Out example project @ [example](example)

## FAQ

Create a feature requests or bugs @ [Feature Request / issue tracker](https://github.com/saginbajracharya/ultimate_particle_fx/issues).
