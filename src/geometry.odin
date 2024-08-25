package main

import "core:math"

hit_sphere :: proc(center: Point3, radius: f64, r: Ray) -> f64 {
	oc := center - r.orig
	a := vec3_dot(r.dir, r.dir)
	b := -2.0 * vec3_dot(r.dir, oc)
	c := vec3_dot(oc, oc) - radius * radius
	discriminant := b * b - 4 * a * c

	// calculate the normal at the point
	if discriminant < 0 {
		return -1.0
	}

	return (-b - math.sqrt(discriminant)) / (2.0 * a)
}
