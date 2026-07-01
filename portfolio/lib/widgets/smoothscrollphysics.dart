import 'package:flutter/material.dart';
// Core physics module required for hardware simulation curves
import 'package:flutter/physics.dart'; 

class SmoothScrollPhysics extends ScrollPhysics {
  const SmoothScrollPhysics({super.parent});

  @override
  SmoothScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SmoothScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Dampens input increments to eliminate sudden, jarring wheel movements
    return offset * 0.70;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.minScrollExtent && position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent; 
    }
    if (position.pixels < position.maxScrollExtent && position.maxScrollExtent < value) {
      return value - position.maxScrollExtent; 
    }
    if (value < position.minScrollExtent && position.pixels <= position.minScrollExtent) {
      return value - position.pixels; 
    }
    if (position.maxScrollExtent <= position.pixels && position.maxScrollExtent < value) {
      return value - position.pixels; 
    }
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    if (velocity.abs() < toleranceFor(position).velocity) {
      return null;
    }
    if (position.outOfRange) {
      return super.createBallisticSimulation(position, velocity);
    }
    
    // Smooth deceleration curve configuration
    return FrictionSimulation(
      0.135, 
      position.pixels, 
      velocity * 0.55,
    );
  }
}
