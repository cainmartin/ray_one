package main

import "math.odin"

Point3 :: Vec3

Ray :: struct {
	orig: Point3,
	dir:  Vec3,
}

ray_new :: proc(origin: Point3, direction: Vec3) -> Ray {
	return Ray{orig = origin, dir = direction}
}

ray_at :: proc(r: Ray, t: f64) -> Point3 {
	return r.orig + Vec3(t * f32(t)) * r.dir
}
