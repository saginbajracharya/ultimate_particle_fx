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
        speed: 0.5,
        maxParticles: 10,
        rotation: 0,
        rotationSpeed: 0.0,
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
| velocity                         | Velocity Offset                                                                 |
| position                         | Position OffSet                                                                 |
| colors                           | List of Colors For A Particle                                                   |
| maxSize                          | Maximum Size of A Particle                                                      |
| minSize                          | Minimum Size of A Particle                                                      |
| lifespan                         | LifeSpan of A Particle                                                          |
| speed                            | Speed of Animation                                                              |
| maxParticles                     | Maximum no of Particles                                                         |
| rotation                         | rotation                                                                        |
| rotationSpeed                    | Speed of rotation                                                               |
| shapes                           | Shapes                                                                          |
| customParticleImage              | Custom Image For A Particle                                                     |
| child                            | Child as a Widget                                                               |

## Check Out example project @ [example](example)

## FAQ

Create a feature requests or bugs @ [Feature Request / issue tracker](https://github.com/saginbajracharya/ultimate_particle_fx/issues).
