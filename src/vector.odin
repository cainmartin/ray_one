package main

import "core:math"
import "core:math/rand"

Vec3 :: [3]f64
Point3 :: [3]f64

vec3_length :: proc(v: Vec3) -> f64 {
	return math.sqrt(vec3_length_squared(v))
}

vec3_length_squared :: proc(v: Vec3) -> f64 {
	return v.x * v.x + v.y * v.y + v.z * v.z
}

vec3_normalize :: proc(v: Vec3) -> Vec3 {
	length := vec3_length(v)
	if length == 0 {
		return v
	}

	return v / length
}

vec3_dot :: proc(a, b: Vec3) -> f64 {
	return a.x * b.x + a.y * b.y + a.z * b.z
}

vec3_cross :: proc(a, b: Vec3) -> Vec3 {
	return Vec3{a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x}
}

vec3_distance :: proc(a, b: Vec3) -> f64 {
	return vec3_length(b - a)
}

vec3_reflect :: proc(v, n: Vec3) -> Vec3 {
	dot_product := vec3_dot(v, n)
	return Vec3 {
		v.x - 2 * dot_product * n.x,
		v.y - 2 * dot_product * n.y,
		v.z - 2 * dot_product * n.z,
	}
}
