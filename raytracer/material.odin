package main

import "core:fmt"
import "core:math"

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

// Dielectric material (always reflects)
Dielectric :: struct {
	refraction_index: f64,
}

dielectric_new :: proc(refraction_index: f64) -> ^Dielectric {
	dielectric := new(Dielectric)
	dielectric.refraction_index = refraction_index

	return dielectric
}

dielectric_scatter :: proc(
	data: rawptr,
	ray_in: Ray,
	rec: HitRecord,
	attenuation: ^Color,
	ray_scattered: ^Ray,
) -> bool {
	dielectric := cast(^Dielectric)data

	attenuation^ = Color{1.0, 1.0, 1.0}
	ri := rec.front_face ? (1.0 / dielectric.refraction_index) : dielectric.refraction_index
	unit_direction := vec3_normalize(ray_in.dir)
	cos_theta := math.min(vec3_dot(-unit_direction, rec.normal), 1.0)
	sin_theta := math.sqrt(1.0 - cos_theta * cos_theta)

	cannot_refract := ri * sin_theta > 1.0
	direction := Vec3{0, 0, 0}

	if cannot_refract || dielectric_reflectance(cos_theta, ri) > random_f64() {
		direction = vec3_reflect(unit_direction, rec.normal)
	} else {
		direction = vec3_refract(unit_direction, rec.normal, ri)
	}

	ray_scattered^ = ray_new(rec.point, direction)

	return true
}

dielectric_reflectance :: proc(cosine: f64, refraction_index: f64) -> f64 {
	r0 := (1 - refraction_index) / (1 + refraction_index)
	r0 = r0 * r0
	return r0 + (1 - r0) * math.pow((1 - cosine), 5)
}
