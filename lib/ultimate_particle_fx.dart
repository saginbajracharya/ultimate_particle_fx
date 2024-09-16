library ultimate_particle_fx;

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:ultimate_particle_fx/particles_enum/movement_direction.dart';
import 'package:ultimate_particle_fx/particles_enum/particle_shapes.dart';
import 'package:ultimate_particle_fx/particles_enum/spawn_position.dart';
import 'package:ultimate_particle_fx/particles_enum/touch_type.dart';

class UltimateParticleFx extends StatefulWidget {
  final bool neverEnding; 
  final Widget child;
  final double width;
  final double height;
  final Offset position;
  final Offset velocity;
  final List<Color> colors;
  final double minSize;
  final double maxSize; 
  final double lifespan;
  final int initialParticles;
  final int maxParticles;
  final double speed;
  final List<ParticleShape> shapes;
  final List<ImageProvider>? customParticleImage;
  final double rotation;
  final double rotationSpeed;
  final Gradient? gradient;
  final bool allowParticlesExitSpawnArea; // Allow Particles to Escape Defined Spawn Area Or Not
  final Offset spawnAreaPosition; // Position of the spawn area
  final SpawnPosition spawnPosition; // Position of the spawn position within spawnArea
  final MovementDirection movementDirection; // Direction of the spawned particles movement
  final double spawnAreaWidth;
  final double spawnAreaHeight;
  final Color? spawnAreaColor;
  final TouchType touchType;

  const UltimateParticleFx({
    super.key,
    this.neverEnding = false,
    this.child = const SizedBox(), 
    this.width = 300,
    this.height = 300,
    this.position = const Offset(0, 0), 
    this.velocity = const Offset(1,1), 
    this.colors = const [Colors.black,Colors.red,Colors.blue],
    this.minSize = 5.0,
    this.maxSize = 6.0,
    this.lifespan = 100.0,
    this.initialParticles = 1,
    this.maxParticles= 100,
    this.speed = 1.0,
    this.shapes = const [ParticleShape.heart],
    this.customParticleImage,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
    this.gradient,
    this.allowParticlesExitSpawnArea = true,
    this.spawnAreaPosition = const Offset(0, 0),
    this.spawnPosition = SpawnPosition.random,
    this.movementDirection = MovementDirection.random,
    this.spawnAreaWidth = double.infinity,
    this.spawnAreaHeight = double.infinity, 
    this.spawnAreaColor = Colors.transparent,
    this.touchType = TouchType.push,
  });

  @override
  UltimateParticleFxState createState() => UltimateParticleFxState();
}

class UltimateParticleFxState extends State<UltimateParticleFx> with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];
  List<ui.Image> customImages = []; // Store pre-loaded images

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1000),
    )..repeat();

    // Load custom images
    loadCustomImages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final containerSize = Size(widget.width, widget.height);
      // Add initial particles
      for (int i = 0; i < widget.maxParticles; i++) {
        final newParticle = createParticle(containerSize);
        if (newParticle != null) {
          particles.add(newParticle);
        }else{
          particles.clear();
        }
      }
      _controller.addListener(() {
        updateParticles(containerSize);
      });
    });
  }

  Future<void> loadCustomImages() async {
    if (widget.customParticleImage != null) {
      for (var imageProvider in widget.customParticleImage!) {
        final imageStream = imageProvider.resolve(const ImageConfiguration());
        final completer = Completer<ui.Image>();
        imageStream.addListener(
          ImageStreamListener(
            (ImageInfo info, bool syncCall) {
              completer.complete(info.image);
            },
            onError: (exception, stackTrace) {
              completer.completeError(exception);
            },
          ),
        );
        try {
          final image = await completer.future;
          customImages.add(image);
        } catch (e) {
          // Handle image loading error
        }
      }
    }
  }

  Particle? createParticle(Size containerSize) {
    if (widget.shapes.isEmpty) {
      particles.clear();
      return null; // Return null if no shapes are defined
    }
    final random = Random();
    final angle = random.nextDouble() * 2 * pi; // Random angle
    final speed = widget.speed; // Use the speed parameter
    double velocityX = speed * cos(angle);
    double velocityY = speed * sin(angle);

    // Calculate spawn position based on SpawnPosition
    double spawnX, spawnY;
    final double spawnAreaWidth = min(widget.spawnAreaWidth, containerSize.width);
    final double spawnAreaHeight = min(widget.spawnAreaHeight, containerSize.height);
    final spawnAreaLeft = widget.spawnAreaPosition.dx;
    final spawnAreaTop = widget.spawnAreaPosition.dy;
    switch (widget.spawnPosition) {
      case SpawnPosition.top:
        spawnX = spawnAreaLeft + random.nextDouble() * spawnAreaWidth; // Add the horizontal offset here
        spawnY = spawnAreaTop;
        break;
      case SpawnPosition.bottom:
        spawnX = spawnAreaLeft + random.nextDouble() * spawnAreaWidth; // Add the horizontal offset here
        spawnY = spawnAreaTop + spawnAreaHeight;
        break;
      case SpawnPosition.left:
        spawnX = spawnAreaLeft; // Already using the correct offset
        spawnY = random.nextDouble() * spawnAreaHeight + spawnAreaTop; // Add vertical offset
        break;
      case SpawnPosition.right:
        spawnX = spawnAreaLeft + spawnAreaWidth; // Already using the correct offset
        spawnY = random.nextDouble() * spawnAreaHeight + spawnAreaTop; // Add vertical offset
        break;
      case SpawnPosition.center:
        spawnX = spawnAreaLeft + spawnAreaWidth / 2; // Correctly use the horizontal offset
        spawnY = spawnAreaTop + spawnAreaHeight / 2; // Correctly use the vertical offset
        break;
      case SpawnPosition.random:
      default:
        spawnX = spawnAreaLeft + random.nextDouble() * spawnAreaWidth; // Add horizontal offset for random spawn
        spawnY = spawnAreaTop + random.nextDouble() * spawnAreaHeight; // Add vertical offset for random spawn
        break;
    }
    // Calculate velocity based on MovementDirection
    switch (widget.movementDirection) {
      case MovementDirection.top:
        velocityX = 0;
        velocityY = -speed;
        break;
      case MovementDirection.bottom:
        velocityX = 0;
        velocityY = speed;
        break;
      case MovementDirection.left:
        velocityX = -speed;
        velocityY = 0;
        break;
      case MovementDirection.right:
        velocityX = speed;
        velocityY = 0;
        break;
      case MovementDirection.center:
        velocityX = 0;
        velocityY = 0;
        break;
      case MovementDirection.random:
      default:
        // Keep the random velocity
        break;
    }

    // Generate a random size between minSize and maxSize
    final size = widget.minSize + random.nextDouble() * (widget.maxSize - widget.minSize);
    return Particle(
      neverEnding: widget.neverEnding,
      child: widget.child,
      width: widget.width,
      height: widget.height,
      position: Offset(spawnX, spawnY),
      velocity: Offset(velocityX, velocityY),
      color: widget.colors.isEmpty? Colors.transparent :widget.colors[random.nextInt(widget.colors.length)],
      size: size,
      lifespan: random.nextDouble() * widget.lifespan, 
      maxParticles: widget.maxParticles,
      shape: widget.shapes[random.nextInt(widget.shapes.length)], 
      customParticleImage: customImages.isNotEmpty ? customImages[random.nextInt(customImages.length)] : null,
      rotation: widget.rotation,
      rotationSpeed: widget.rotationSpeed,
      gradient: widget.gradient,
    );
  }

  void updateParticles(Size containerSize) {
    if (widget.shapes.isEmpty) {
      particles.clear();
      return; // Skip updating particles if no shapes are defined
    }
    setState(() {
      for (var particle in particles) {
        particle.position += particle.velocity;

        // Ensure particles stay within the spawn area
        if (!widget.allowParticlesExitSpawnArea) {
          double spawnAreaLeft = widget.spawnAreaPosition.dx;
          double spawnAreaTop = widget.spawnAreaPosition.dy;
          double spawnAreaRight = spawnAreaLeft + widget.spawnAreaWidth;
          double spawnAreaBottom = spawnAreaTop + widget.spawnAreaHeight;

          // Adjust position if out of bounds
          if (particle.position.dx < spawnAreaLeft) {
            particle.position = Offset(spawnAreaLeft, particle.position.dy);
            particle.velocity = Offset(particle.velocity.dx.abs(), particle.velocity.dy); // Reflect velocity
          } else if (particle.position.dx > spawnAreaRight) {
            particle.position = Offset(spawnAreaRight, particle.position.dy);
            particle.velocity = Offset(-particle.velocity.dx.abs(), particle.velocity.dy); // Reflect velocity
          }
          
          if (particle.position.dy < spawnAreaTop) {
            particle.position = Offset(particle.position.dx, spawnAreaTop);
            particle.velocity = Offset(particle.velocity.dx, particle.velocity.dy.abs()); // Reflect velocity
          } else if (particle.position.dy > spawnAreaBottom) {
            particle.position = Offset(particle.position.dx, spawnAreaBottom);
            particle.velocity = Offset(particle.velocity.dx, -particle.velocity.dy.abs()); // Reflect velocity
          }
        }

        // Remove particles whose lifespan has ended
        particle.lifespan -= 1; // Decrease lifespan at a constant rate
      }
      // Remove particles whose lifespan has ended
      particles.removeWhere((particle) => particle.lifespan <= 0);
      // Regenerate particles if not never-ending
      if (widget.neverEnding) {
        int missingParticles = widget.maxParticles - particles.length;
        for (int i = 0; i < missingParticles; i++) {
          final newParticle = createParticle(containerSize);
          if (newParticle != null) {
            particles.add(newParticle);
          }
          else{
            particles.clear();
          }
        }
      }
    });
  }

  void handleTouch(Offset touchPosition) {
    const double threshold = 100; // You can adjust this threshold as needed
    const double forceDivisor = 50; // Controls the slow movement speed
  
    if(widget.touchType == TouchType.push){
      setState(() {
        for (var particle in particles) {
          final distance = (particle.position - touchPosition).distance;
          if (distance < 100) { // Adjust this threshold as needed
            // Calculate the force magnitude with a lower multiplier for slower movement
            final forceMagnitude = (100 - distance) / 50; // Reduced factor for slower movement
            
            // Calculate the direction and normalize it
            final direction = (particle.position - touchPosition);
            final directionMagnitude = direction.distance;

            final normalizedDirection = direction / directionMagnitude;
            
            // Apply the force to the particle velocity
            particle.velocity += normalizedDirection * forceMagnitude;
          }
        }
      });
    }
    else if(widget.touchType == TouchType.holdAndGrow){
      for (var particle in particles) {
        final distance = (particle.position - touchPosition).distance;

        if (distance < threshold) {
          // Apply an instantaneous outward velocity
          final forceMagnitude = (threshold - distance) / forceDivisor;

          // Randomize the explosion direction for each particle
          final randomAngle = Random().nextDouble() * 2 * pi; // random angle in radians
          final explosionDirection = Offset(cos(randomAngle), sin(randomAngle));

          // Apply the initial burst velocity in random directions
          particle.velocity = explosionDirection * forceMagnitude;

          // Reduce the lifespan of the particle to simulate it fading quickly
          particle.lifespan -= 5;

          // Optional: Make particles expand a little
          particle.size *= 1.05; // Increase size slightly during explosion

          // Gradually reduce opacity based on lifespan to create the fading effect
          final opacityFactor = (particle.lifespan / 100).clamp(0.0, 1.0);
          particle.color = particle.color.withOpacity(opacityFactor);
        }
      }

      // Remove particles with a lifespan <= 0
      particles.removeWhere((particle) => particle.lifespan <= 0);
    }
    else if (widget.touchType == TouchType.swirl) {
      for (var particle in particles) {
        final distance = (particle.position - touchPosition).distance;

        if (distance < threshold) {
          // Calculate a swirling force with a circular motion
          final forceMagnitude = (threshold - distance) / forceDivisor;

          // Circular motion using sine and cosine
          final swirlAngle = atan2(particle.position.dy - touchPosition.dy, particle.position.dx - touchPosition.dx) + pi / 4;
          final swirlDirection = Offset(cos(swirlAngle), sin(swirlAngle));

          // Apply the swirling velocity
          particle.velocity = swirlDirection * forceMagnitude;

          // Gradually decrease lifespan
          particle.lifespan -= 2;
        }
      }

      particles.removeWhere((particle) => particle.lifespan <= 0);
    }
    else if (widget.touchType == TouchType.implode) {
      for (var particle in particles) {
        final distance = (particle.position - touchPosition).distance;

        if (distance < threshold) {
          // Calculate a force that pulls particles inward
          final forceMagnitude = (threshold - distance) / forceDivisor;

          // Direction towards the touch position
          final direction = (touchPosition - particle.position);
          final normalizedDirection = direction / direction.distance;

          // Apply force towards the touch point
          particle.velocity += normalizedDirection * forceMagnitude;

          // Reduce lifespan to make particles disappear faster
          particle.lifespan -= 3;
        }
      }

      particles.removeWhere((particle) => particle.lifespan <= 0);
    }
    else if (widget.touchType == TouchType.scatter) {
      for (var particle in particles) {
        // Random direction
        final randomAngle = Random().nextDouble() * 2 * pi;
        final scatterDirection = Offset(cos(randomAngle), sin(randomAngle));

        // Random burst of velocity in a random direction
        particle.velocity = scatterDirection * (Random().nextDouble() * 5);

        // Gradually reduce lifespan
        particle.lifespan -= 4;

        // Random size increase to create a "burst" effect
        particle.size *= 1.1;
      }

      particles.removeWhere((particle) => particle.lifespan <= 0);
    }
    else if (widget.touchType == TouchType.shrinkAndVanish) {
      for (var particle in particles) {
        final distance = (particle.position - touchPosition).distance;

        if (distance < threshold) {
          // No velocity change, just shrink and fade out
          particle.size *= 0.95; // Shrink
          particle.lifespan -= 5; // Faster fade out

          // Gradually reduce opacity based on lifespan
          final opacityFactor = (particle.lifespan / 100).clamp(0.0, 1.0);
          particle.color = particle.color.withOpacity(opacityFactor);
        }
      }
      particles.removeWhere((particle) => particle.lifespan <= 0);
    }
    else if (widget.touchType == TouchType.ripple) {
      for (var particle in particles) {
        final distance = (particle.position - touchPosition).distance;

        if (distance < threshold) {
          // No outward velocity applied

          // Gradually increase size for the ripple effect
          particle.size *= 1.02;

          // Gradually reduce lifespan to make the particles fade out
          particle.lifespan -= 2;

          // Optionally, change the color to give a fade effect (based on lifespan)
          final opacityFactor = (particle.lifespan / 100).clamp(0.0, 1.0);
          particle.color = particle.color.withOpacity(opacityFactor);
        }
      }

      // Remove particles that have no lifespan left
      particles.removeWhere((particle) => particle.lifespan <= 0);
    }
  }

  // Function to determine alignment based on spawn direction
  Alignment getSpawnAlignment(spawnPosition) {
    switch (spawnPosition) {
      case SpawnPosition.top:
        return Alignment.topCenter;
      case SpawnPosition.bottom:
        return Alignment.bottomCenter;
      case SpawnPosition.left:
        return Alignment.centerLeft;
      case SpawnPosition.right:
        return Alignment.centerRight;
      case SpawnPosition.random:
        return Alignment.center; // Create random alignment logic
      default:
        return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Update the particles' behavior based on the touch
        handleTouch(details.localPosition);
      },
      child: Stack(
        children: [
          if (widget.spawnAreaColor != Colors.transparent)
            Positioned(
              left: widget.spawnAreaPosition.dx,
              top: widget.spawnAreaPosition.dy,
              child: Container(
                width: widget.spawnAreaWidth,
                height: widget.spawnAreaHeight,
                color: widget.spawnAreaColor,
              ),
            ),
          CustomPaint(
            size: Size(widget.width, widget.height),
            painter: ParticlePainter(particles, widget.width, widget.height),
            child: widget.child,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Particle {
  bool neverEnding; 
  Widget child;
  double width;
  double height;
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double lifespan;
  int maxParticles;
  ParticleShape shape;
  ui.Image? customParticleImage;
  double rotation;
  double rotationSpeed;
  Gradient? gradient;

  Particle({
    required this.neverEnding,
    required this.child,
    required this.width,
    required this.height,
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.lifespan,
    required this.maxParticles,
    required this.shape,
    required this.customParticleImage,
    required this.rotation,
    required this.rotationSpeed,
    required this.gradient,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double width;
  final double height;

  ParticlePainter(this.particles, this.width, this.height);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
      ..style = PaintingStyle.fill;
      // Check if particle has a gradient
      if (particle.gradient != null) {
        final rect = Rect.fromCenter(
          center: particle.position,
          width: particle.size,
          height: particle.size,
        );
        paint.shader = particle.gradient!.createShader(rect);
      } else {
        // Use solid color if gradient is not provided
        paint.color = particle.color.withOpacity(
          (particle.lifespan / 100).clamp(0.0, 1.0),
        );
      }
      canvas.save(); // Save canvas state
      try{
        // Apply rotation transformation
        final rotationAngle = particle.rotation + particle.rotationSpeed;
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(rotationAngle);
        canvas.translate(-particle.position.dx, -particle.position.dy);
        switch (particle.shape) {
          case ParticleShape.circle:
            canvas.drawCircle(particle.position, particle.size, paint);
            break;
          case ParticleShape.square:
            canvas.drawRect(
              Rect.fromCenter(center: particle.position, width: particle.size, height: particle.size),
              paint,
            );
            break;
          case ParticleShape.triangle:
            final path = Path()
              ..moveTo(particle.position.dx, particle.position.dy - particle.size)
              ..lineTo(particle.position.dx - particle.size, particle.position.dy + particle.size)
              ..lineTo(particle.position.dx + particle.size, particle.position.dy + particle.size)
              ..close();
            canvas.drawPath(path, paint);
            break;
          case ParticleShape.star:
            final path = Path()
              ..moveTo(particle.position.dx, particle.position.dy - particle.size)
              ..lineTo(particle.position.dx + particle.size * 0.225, particle.position.dy - particle.size * 0.225)
              ..lineTo(particle.position.dx + particle.size, particle.position.dy)
              ..lineTo(particle.position.dx + particle.size * 0.225, particle.position.dy + particle.size * 0.225)
              ..lineTo(particle.position.dx, particle.position.dy + particle.size)
              ..lineTo(particle.position.dx - particle.size * 0.225, particle.position.dy + particle.size * 0.225)
              ..lineTo(particle.position.dx - particle.size, particle.position.dy)
              ..lineTo(particle.position.dx - particle.size * 0.225, particle.position.dy - particle.size * 0.225)
              ..close();
            canvas.drawPath(path, paint);
            break;
          case ParticleShape.hexagon:
            final path = Path()
              ..moveTo(particle.position.dx + particle.size * cos(pi / 6), particle.position.dy - particle.size * sin(pi / 6))
              ..lineTo(particle.position.dx + particle.size * cos(pi / 6), particle.position.dy + particle.size * sin(pi / 6))
              ..lineTo(particle.position.dx, particle.position.dy + particle.size)
              ..lineTo(particle.position.dx - particle.size * cos(pi / 6), particle.position.dy + particle.size * sin(pi / 6))
              ..lineTo(particle.position.dx - particle.size * cos(pi / 6), particle.position.dy - particle.size * sin(pi / 6))
              ..lineTo(particle.position.dx, particle.position.dy - particle.size)
              ..close();
            canvas.drawPath(path, paint);
            break;
          case ParticleShape.diamond:
            final path = Path()
              ..moveTo(particle.position.dx, particle.position.dy - particle.size)
              ..lineTo(particle.position.dx + particle.size, particle.position.dy)
              ..lineTo(particle.position.dx, particle.position.dy + particle.size)
              ..lineTo(particle.position.dx - particle.size, particle.position.dy)
              ..close();
            canvas.drawPath(path, paint);
            break;
          case ParticleShape.pentagon:
            final path = Path()
              ..moveTo(particle.position.dx + particle.size * cos(0), particle.position.dy + particle.size * sin(0));
            for (int i = 1; i <= 5; i++) {
              final angle = i * 2 * pi / 5;
              path.lineTo(particle.position.dx + particle.size * cos(angle), particle.position.dy + particle.size * sin(angle));
            }
            path.close();
            canvas.drawPath(path, paint);
            break;
          case ParticleShape.ellipse:
            final rect = Rect.fromCenter(center: particle.position, width: particle.size * 1.5, height: particle.size);
            canvas.drawOval(rect, paint);
            break;
          case ParticleShape.cross:
            final rect1 = Rect.fromCenter(center: particle.position, width: particle.size, height: particle.size * 2);
            final rect2 = Rect.fromCenter(center: particle.position, width: particle.size * 2, height: particle.size);
            canvas.drawRect(rect1, paint);
            canvas.drawRect(rect2, paint);
            break;
          case ParticleShape.heart:
            final path = Path();
            final double width = particle.size * 2; // Width of the heart
            final double height = particle.size * 2; // Height of the heart

            // Move to the starting point of the left lobe
            path.moveTo(particle.position.dx + 0.5 * width, particle.position.dy + 0.4 * height);

            // Draw the left lobe using a cubic Bézier curve
            path.cubicTo(
              particle.position.dx + 0.2 * width, particle.position.dy + 0.1 * height,
              particle.position.dx - 0.25 * width, particle.position.dy + 0.6 * height,
              particle.position.dx + 0.5 * width, particle.position.dy + height
            );

            // Move to the starting point of the right lobe
            path.moveTo(particle.position.dx + 0.5 * width, particle.position.dy + 0.4 * height);

            // Draw the right lobe using a cubic Bézier curve
            path.cubicTo(
              particle.position.dx + 0.8 * width, particle.position.dy + 0.1 * height,
              particle.position.dx + 1.25 * width, particle.position.dy + 0.6 * height,
              particle.position.dx + 0.5 * width, particle.position.dy + height
            );

            // Use fill style to ensure the shape is completely filled with color
            final paint = Paint()
              ..style = PaintingStyle.fill;

            // Use gradient if provided
            if (particle.gradient != null) {
              final rect = Rect.fromCenter(
                center: particle.position,
                width: width,
                height: height,
              );
              paint.shader = particle.gradient!.createShader(rect);
            } else {
              // Use solid color if gradient is not provided
              paint.color = particle.color.withOpacity(
                (particle.lifespan / 100).clamp(0.0, 1.0),
              );
            }

            canvas.drawPath(path, paint);
            break;
          case ParticleShape.arrow:
            final path = Path()
              // Arrowhead
              ..moveTo(particle.position.dx, particle.position.dy - particle.size) // Top of the head
              ..lineTo(particle.position.dx + particle.size * 0.5, particle.position.dy) // Right side of the head
              ..lineTo(particle.position.dx - particle.size * 0.5, particle.position.dy) // Left side of the head
              ..close();

            // Draw the tail
            final tailPath = Path()
              ..moveTo(particle.position.dx, particle.position.dy) // Base of the head
              ..lineTo(particle.position.dx, particle.position.dy + particle.size * 1.5); // Tail line

            // Draw the paths with the same paint
            canvas.drawPath(path, paint);
            canvas.drawPath(tailPath, paint..style = PaintingStyle.stroke..strokeWidth = 3.0); // Tail with stroke
            break;
          case ParticleShape.cloud:
            final path = Path();
            final double x = particle.position.dx;
            final double y = particle.position.dy;
            final double size = particle.size;

            // Start the path at the bottom left of the cloud
            path.moveTo(x - size * 0.6, y);

            // Create the bottom curve of the cloud
            path.quadraticBezierTo(x - size * 0.4, y + size * 0.3, x, y + size * 0.2);
            path.quadraticBezierTo(x + size * 0.4, y + size * 0.3, x + size * 0.6, y);

            // Create the right curve of the cloud
            path.quadraticBezierTo(x + size * 0.8, y - size * 0.4, x + size * 0.4, y - size * 0.5);

            // Create the top curve of the cloud
            path.quadraticBezierTo(x, y - size * 0.6, x - size * 0.4, y - size * 0.5);

            // Create the left curve of the cloud and close the path
            path.quadraticBezierTo(x - size * 0.8, y - size * 0.4, x - size * 0.6, y);

            // Draw the cloud shape
            canvas.drawPath(path, paint);
            break;
          case ParticleShape.octagon:
            final path = Path()
              ..moveTo(particle.position.dx + particle.size * cos(0), particle.position.dy + particle.size * sin(0));
            for (int i = 1; i <= 8; i++) {
              final angle = i * 2 * pi / 8;
              path.lineTo(particle.position.dx + particle.size * cos(angle), particle.position.dy + particle.size * sin(angle));
            }
            path.close();
            canvas.drawPath(path, paint);
            break;
          case ParticleShape.custom:
            if (particle.customParticleImage != null) {
              final img = particle.customParticleImage!;
              final Rect dstRect = Rect.fromCenter(
                center: particle.position,
                width: particle.size,
                height: particle.size,
              );
              // Debugging: Draw a rectangle where the image should be
              // canvas.drawRect(dstRect, Paint()..color = Colors.red.withOpacity(0.5));
              // Draw the image on the canvas
              canvas.drawImageRect(
                img,
                Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
                dstRect,
                Paint(),
              );
            }
            break;
        }
      }finally{
        // Always restore the canvas state
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}