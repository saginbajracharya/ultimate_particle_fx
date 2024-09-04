library ultimate_particle_fx;

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

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
  final int maxParticles;
  final double speed;
  final List<ParticleShape> shapes;
  final List<ImageProvider>? customParticleImage;
  final double rotation;
  final double rotationSpeed;

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
    this.maxSize = 10.0,
    this.lifespan = 100.0,
    this.maxParticles= 100,
    this.speed = 1.0,
    this.shapes = const [ParticleShape.circle],
    this.customParticleImage,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
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
        particles.add(createParticle(containerSize));
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

  Particle createParticle(Size containerSize) {
    final random = Random();
    final angle = random.nextDouble() * 2 * pi; // Random angle
    final speed = widget.speed; // Use the speed parameter
    final velocityX = speed * cos(angle);
    final velocityY = speed * sin(angle);
    // Generate a random size between minSize and maxSize
    final size = widget.minSize + random.nextDouble() * (widget.maxSize - widget.minSize);
    return Particle(
      neverEnding: widget.neverEnding,
      child: widget.child,
      width: widget.width,
      height: widget.height,
      position: Offset(
        random.nextDouble() * containerSize.width,
        random.nextDouble() * containerSize.height,
      ),
      velocity: Offset(velocityX, velocityY),
      color: widget.colors[random.nextInt(widget.colors.length)],
      size: size,
      lifespan: random.nextDouble() * widget.lifespan, 
      maxParticles: widget.maxParticles,
      shape: widget.shapes[random.nextInt(widget.shapes.length)], 
      customParticleImage: customImages.isNotEmpty ? customImages[random.nextInt(customImages.length)] : null,
      rotation: widget.rotation,
      rotationSpeed: widget.rotationSpeed,
    );
  }

  void updateParticles(Size containerSize) {
    setState(() {
      for (var particle in particles) {
        particle.position += particle.velocity;
        particle.position = Offset(
          particle.position.dx.clamp(0.0, containerSize.width),
          particle.position.dy.clamp(0.0, containerSize.height),
        );
        particle.lifespan -= 1; // Decrease lifespan at a constant rate
      }

      // Remove particles whose lifespan has ended
      particles.removeWhere((particle) => particle.lifespan <= 0);

      // Regenerate particles if not never-ending
      if (widget.neverEnding) {
        int missingParticles = widget.maxParticles - particles.length;
        for (int i = 0; i < missingParticles; i++) {
          particles.add(createParticle(containerSize));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: ParticlePainter(particles),
      child: widget.child,
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
  });
}

enum ParticleShape {
  circle,
  square,
  triangle,
  star,
  hexagon,
  diamond,
  pentagon,
  ellipse,
  cross,
  heart,
  arrow,
  cloud,
  octagon,
  custom,
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
      ..color = particle.color.withOpacity((particle.lifespan / 100).clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;
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
              ..color = particle.color
              ..style = PaintingStyle.fill;

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