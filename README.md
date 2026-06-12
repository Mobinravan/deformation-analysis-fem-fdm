# Deformation Analysis Using Finite Difference (FDM) and Finite Element (FEM) Methods

Numerical simulation of displacement field and strain tensor calculation for a partitioned plate with three distinct motion regimes.

## Overview

This project simulates a geodynamic network (10 km × 5 km) divided into three zones, each with predefined motion. A synthetic displacement field is generated at 90 random points (30 per zone). Two numerical methods are then applied and compared:

1. **Finite Difference Method (FDM)** – Regular grid interpolation + central differences
2. **Finite Element Method (FEM)** – Delaunay triangulation + linear shape functions

From the displacement gradient, the strain tensor and its invariants (dilatation, maximum shear, rotation) are computed and visualized.

## Problem Geometry

| Parameter | Value |
|-----------|-------|
| Total width | 10,000 m |
| Total height | 5,000 m |
| Horizontal boundary (Y) | 2,500 m |
| Vertical boundary (X) | 5,000 m |

## Motion Definitions

| Zone | Position | Motion Type | Displacement |
|------|----------|-------------|--------------|
| **A** | Upper half (y ≥ 2500) | SW Translation | Ux = -171.5 m, Uy = -102.9 m |
| **B** | Lower-right (x ≥ 5000, y < 2500) | NW Translation | Ux = -156.2 m, Uy = +124.9 m |
| **C** | Lower-left (x < 5000, y < 2500) | Pure Rotation | 5° about center (2500, 1250) |

## Numerical Methods

### Finite Difference Method (FDM)

A regular grid (50 × 30 points) is created. Displacement values are interpolated onto grid nodes. Partial derivatives are approximated using central differences:

| Derivative | Finite Difference Approximation |
|------------|-------------------------------|
| ∂Ux/∂x | (Ux(i,j+1) - Ux(i,j-1)) / (2Δx) |
| ∂Ux/∂y | (Ux(i+1,j) - Ux(i-1,j)) / (2Δy) |
| ∂Uy/∂x | (Uy(i,j+1) - Uy(i,j-1)) / (2Δx) |
| ∂Uy/∂y | (Uy(i+1,j) - Uy(i-1,j)) / (2Δy) |

### Finite Element Method (FEM)

Delaunay triangulation connects the 90 random points into triangular elements. Within each triangle, displacement fields are assumed linear:

Coefficients (a₁, a₂, b₁, b₂) are solved per triangle, giving constant strain within each element.

## Strain Tensor and Invariants

| Component | Formula |
|-----------|---------|
| ε_xx | ∂Ux/∂x |
| ε_yy | ∂Uy/∂y |
| ε_xy | 0.5 × (∂Ux/∂y + ∂Uy/∂x) |

### Invariants

| Invariant | Formula | Meaning |
|-----------|---------|---------|
| Dilatation (Δ) | ε_xx + ε_yy | Relative area change |
| Maximum Shear (Γ_max) | √[((ε_xx - ε_yy)/2)² + ε_xy²] | Maximum shear strain |
| Rotation (Φ) | 0.5 × (∂Uy/∂x - ∂Ux/∂y) | Local rigid body rotation |

### Key Findings

- **Rotation invariant (Φ)** successfully distinguishes rotational motion (Zone C) from translational motion (Zones A and B)
- **Maximum shear (Γ_max)** concentrates at the horizontal boundary (Y = 2500 m) – indicating a potential failure zone
- **Dilatation (Δ)** remains near zero within all zones, confirming rigid-body motion
- **FDM vs FEM:** Both methods agree; FEM is better suited for randomly distributed data
