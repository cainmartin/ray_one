package main

INFINITY :: max(f64)
PI :: 3.1415926535897932385

degrees_to_radians :: proc(degrees: f64) -> f64 {
	return (degrees * PI) / 180.0
}
