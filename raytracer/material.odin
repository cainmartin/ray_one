package main

import "core:fmt"

Material :: struct {
	data:    rawptr,
	scatter: proc(
		data: rawptr,
		ray_int: Ray,
		rec: HitRecord,
		attentuation: Color,
		ray_scattered: Ray,
	) -> bool,
}

// Lambertian material
Lambertian :: struct {
	albedo: Color,
}

// *object*_destroy should clean up this memory
lambertian_new :: proc(albedo: Color) -> ^Lambertian {
	lambertian := new(Lambertian)
	lambertian.albedo = albedo
	return lambertian
}

lambertian_scatter :: proc(
	data: rawptr,
	ray_int: Ray,
	rec: HitRecord,
	attentuation: Color,
	ray_scattered: Ray,
) -> bool {
	fmt.println("I'm here")
	return false
}
