package main

Point3 :: Vec3

Ray :: struct {
	orig: Point3,
	dir:  Vec3,
}

ray_new :: proc(origin: Point3, direction: Vec3) -> Ray {
	return Ray{orig = origin, dir = direction}
}

ray_at :: proc(r: Ray, t: f64) -> Point3 {
	return r.orig + Vec3(t * t) * r.dir
}

// TODO: Need to do calculation for the color
ray_color :: proc(r: Ray) -> Color {
	unit_direction := vec3_normalize(r.dir)
	a := 0.5 * unit_direction.y + 1.0

	return (1.0 - a) * Color{1.0, 1.0, 1.0} + a * Color{0.5, 0.7, 1.0}
}
