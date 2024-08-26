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
	return r.orig + t * r.dir
}

// TODO: Need to do calculation for the color
ray_color :: proc(r: Ray) -> Color {
	t := hit_sphere(Vec3{0.0, 0.0, -1.0}, 0.5, r)

	if t > 0.0 {
		n := vec3_normalize(ray_at(r, t) - Vec3{0.0, 0.0, -1.0})
		return 0.5 * Color{n.x + 1.0, n.y + 1.0, n.z + 1.0}
	}

	unit_direction := vec3_normalize(r.dir)
	a := 0.5 * unit_direction.y + 1.0

	return (1.0 - a) * Color{1.0, 1.0, 1.0} + a * Color{0.5, 0.7, 1.0}
}
