package main

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

ray_color :: proc(r: Ray, world: ^HittableList) -> Color {
	rec: HitRecord
	if hit(world, r, 0, INFINITY, &rec) {
		return 0.5 * (rec.normal + Color{1, 1, 1})
	}

	unit_direction := vec3_normalize(r.dir)
	a := 0.5 * unit_direction.y + 1.0

	return (1.0 - a) * Color{1.0, 1.0, 1.0} + a * Color{0.5, 0.7, 1.0}
}
