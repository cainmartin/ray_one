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
