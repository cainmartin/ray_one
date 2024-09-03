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

vec3_random_in_unit_disk :: proc() -> Vec3 {
	for {
		p := Vec3{random_f64_range(-1, 1), random_f64_range(-1, 1), 0}
		if vec3_length_squared(p) < 1 {
			return p
		}
	}
}

vec3_random_in_unit_sphere :: proc() -> Vec3 {
	for {
		p := vec3_random(-1.0, 1.0)
		if vec3_length_squared(p) < 1 {
			return p
		}
	}
}

vec3_random_unit_vector :: proc() -> Vec3 {
	return vec3_normalize(vec3_random_in_unit_sphere())
}

vec3_random_unit_vector_on_hemisphere :: proc(normal: Vec3) -> Vec3 {
	on_unit_sphere := vec3_random_unit_vector()
	if vec3_dot(on_unit_sphere, normal) > 0.0 {
		return on_unit_sphere
	} else {
		return -on_unit_sphere
	}
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
	return v - 2.0 * vec3_dot(v, n) * n
}

vec3_refract :: proc(uv: Vec3, n: Vec3, etai_over_etat: Vec3) -> Vec3 {
	cos_theta := math.min(vec3_dot(-uv, n), 1.0)
	r_out_perp := etai_over_etat * (uv + cos_theta * n)
	r_out_parallel := -math.sqrt(math.abs(1.0 - vec3_length_squared(r_out_perp))) * n

	return r_out_perp + r_out_parallel
}

vec3_random :: proc(min: f64, max: f64) -> Vec3 {
	return Vec3{random_f64_range(min, max), random_f64_range(min, max), random_f64_range(min, max)}
}

// Returns true if the vector is close to zero in all directions
vec3_near_zero :: proc(vec: Vec3) -> bool {
	s := 1e-8
	return math.abs(vec.x) < s && math.abs(vec.y) < s && math.abs(vec.z) < s
}
