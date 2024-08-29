package main

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

// TODO: I probably want a standard to know if "_new" allocates on the heap/stack
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
	return false
}

// lambertian_new :: proc(albedo: Color) -> Lambertian {
// 	return Lambertian{albedo = albedo, base = Material{scatter = lambertian_scatter}}
// }
