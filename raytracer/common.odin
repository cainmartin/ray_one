package main

import "core:math/rand"
import "core:time"

INFINITY :: max(f64)
PI :: 3.1415926535897932385

degrees_to_radians :: proc(degrees: f64) -> f64 {
	return (degrees * PI) / 180.0
}

random_f64 :: proc() -> f64 {
	return rand.float64_range(0, 1)
}

random_f64_range :: proc(min: f64, max: f64) -> f64 {
	return min + (max - min) * random_f64()
}

// Gives us values within a 1 pixel square
sample_square :: proc() -> Vec3 {
    return Vec3 { random_f64() - 0.5, random_f64() - 0.5, 0.0 }
}

// Interval class
Interval :: struct {
	min: f64,
	max: f64,
}

// Default interval is empty
interval_new :: proc(min: f64 = INFINITY, max: f64 = -INFINITY) -> Interval {
	return Interval{min = min, max = max}
}

interval_size :: proc(interval: Interval) -> f64 {
	return interval.max - interval.min
}

interval_contains :: proc(interval: Interval, x: f64) -> bool {
	return interval.min <= x && x <= interval.max
}

interval_surrounds :: proc(interval: Interval, x: f64) -> bool {
	return interval.min < x && x < interval.max
}

interval_clamp :: proc(interval: Interval, val: f64) -> f64 {
	if (val < interval.min) { return interval.min }
	if (val > interval.max) { return interval.max }
	return val
}

// Constant interval structs for convenience
EMPTY :: Interval{INFINITY, -INFINITY}
UNIVERSE :: Interval{-INFINITY, INFINITY}
