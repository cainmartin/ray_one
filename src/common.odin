package main

INFINITY :: max(f64)
PI :: 3.1415926535897932385

degrees_to_radians :: proc(degrees: f64) -> f64 {
	return (degrees * PI) / 180.0
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

// Constant interval structs for convenience
EMPTY :: Interval{INFINITY, -INFINITY}
UNIVERSE :: Interval{-INFINITY, INFINITY}
