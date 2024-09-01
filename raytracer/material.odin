package main

import "core:fmt"

Material :: struct {
	data:    rawptr,
	scatter: proc(
		data: rawptr,
		ray_in: Ray,
		rec: HitRecord,
		attenuation: ^Color,
		ray_scattered: ^Ray,
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
	ray_in: Ray,
	rec: HitRecord,
	attenuation: ^Color,
	ray_scattered: ^Ray,
) -> bool {
	lambertian := cast(^Lambertian)data

	scatter_direction := rec.normal + vec3_random_unit_vector()
	if vec3_near_zero(scatter_direction) {
		scatter_direction = rec.normal
	}

	ray_scattered^ = ray_new(rec.point, scatter_direction)
	attenuation^ = lambertian.albedo

	return true
}

// Metal material
Metal :: struct {
	albedo: Color,
	fuzz:   f64,
}

metal_new :: proc(albedo: Color, fuzz: f64) -> ^Metal {
	metal := new(Metal)
	metal.albedo = albedo
	metal.fuzz = fuzz < 1 ? fuzz : 1
	return metal
}

metal_scatter :: proc(
	data: rawptr,
	ray_in: Ray,
	rec: HitRecord,
	attenuation: ^Color,
	ray_scattered: ^Ray,
) -> bool {
	metal := cast(^Metal)data

	reflected := vec3_reflect(ray_in.dir, rec.normal)
	reflected = vec3_normalize(reflected) + (metal.fuzz * vec3_random_unit_vector())
	ray_scattered^ = ray_new(rec.point, reflected)
	attenuation^ = metal.albedo

	return vec3_dot(ray_scattered.dir, rec.normal) > 0
}
