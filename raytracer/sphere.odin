package main

import "core:fmt"
import "core:math"
import "core:mem"

Sphere :: struct {
	center:   Vec3,
	radius:   f64,
	material: ^Material,
}

sphere_new :: proc(center: Vec3, radius: f64, material: ^Material) -> ^Sphere {
	lambertian := lambertian_new(Color{0.5, 0.7, 0.3})
	sphere := new(Sphere)
	sphere.center = center
	sphere.radius = radius
	sphere.material = material

	return sphere
}

sphere_destroy :: proc(data: rawptr) {
	sphere := cast(^Sphere)data
	if sphere.material != nil {
		if sphere.material.data != nil {
			free(sphere.material.data)
		}
		free(sphere.material)
	}
	free(sphere)
}

sphere_hit :: proc(data: rawptr, ray: Ray, ray_t: Interval, hit_record: ^HitRecord) -> bool {
	sphere := cast(^Sphere)data
	oc := sphere.center - ray.orig
	a := vec3_length_squared(ray.dir)
	h := vec3_dot(ray.dir, oc)
	c := vec3_length_squared(oc) - sphere.radius * sphere.radius

	discriminant := h * h - a * c
	if discriminant < 0 {return false}

	sqrtd := math.sqrt(discriminant)

	// Find the nearest root that lies within the acceptable range
	root := (h - sqrtd) / a
	if !interval_surrounds(ray_t, root) {
		root = (h + sqrtd) / a
		if !interval_surrounds(ray_t, root) {
			return false
		}
	}

	hit_record.t = root
	hit_record.point = ray_at(ray, hit_record.t)
	hit_record.material = sphere.material
	outward_normal := (hit_record.point - sphere.center) / sphere.radius
	set_face_normal(hit_record, ray, outward_normal)

	return true
}
