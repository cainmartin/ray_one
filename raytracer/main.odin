package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:os"
import "core:strings"

// TODO:
// - Possibly change the vector / point types to use distinct - then refactor to ensure these are used correctly
// - General cleanup
// -- Especially use of single letter variables
// -- Change variable names so we don't use abbreviations, like orig and dir

main :: proc() {
	fmt.println("Book 1 - Raytracing in a weekend")

	// Create the world
	world: HittableList

	material_ground := new(Material)
	material_ground^ = Material {
		data    = lambertian_new(Color{0.5, 0.5, 0.5}),
		scatter = lambertian_scatter,
	}

	sphere_ground := sphere_new(Vec3{0.0, -1000.0, -1.0}, 1000.0, material_ground)
	append(
		&world.objects,
		Hittable{hit = sphere_hit, destroy = sphere_destroy, data = sphere_ground},
	)

	for a := -11; a < 11; a += 1 {
		for b := -11; b < 11; b += 1 {
			choose_mat := random_f64()
			center := Point3{cast(f64)a + 0.9 * random_f64(), 0.2, cast(f64)b + 0.9 * random_f64()}


			if vec3_length(center - Point3{4.0, 0.2, 0.0}) > 0.9 { 	// Lambertian
				material := new(Material)
				material^ = Material {
					data    = lambertian_new(color_random() * color_random()),
					scatter = lambertian_scatter,
				}

				sphere := sphere_new(center, 0.2, material)
				append(
					&world.objects,
					Hittable{hit = sphere_hit, destroy = sphere_destroy, data = sphere},
				)
			} else if choose_mat < 0.95 { 	// Metal
				material := new(Material)
				material^ = Material {
					data    = metal_new(color_random_range(0.5, 1.0), random_f64_range(0, 0.5)),
					scatter = metal_scatter,
				}

				sphere := sphere_new(center, 0.2, material)
				append(
					&world.objects,
					Hittable{hit = sphere_hit, destroy = sphere_destroy, data = sphere},
				)
			} else { 	// Glass
				material := new(Material)
				material^ = Material {
					data    = dielectric_new(1.5),
					scatter = dielectric_scatter,
				}

				sphere := sphere_new(center, 0.2, material)
				append(
					&world.objects,
					Hittable{hit = sphere_hit, destroy = sphere_destroy, data = sphere},
				)
			}
		}
	}

	material1 := new(Material)
	material1^ = Material {
		data    = dielectric_new(1.5),
		scatter = dielectric_scatter,
	}

	sphere1 := sphere_new(Point3{-4, 1, 0}, 0.2, material1)
	append(&world.objects, Hittable{hit = sphere_hit, destroy = sphere_destroy, data = sphere1})


	material2 := new(Material)
	material2^ = Material {
		data    = lambertian_new(Color{0.4, 0.2, 0.1}),
		scatter = lambertian_scatter,
	}

	sphere2 := sphere_new(Point3{-4, 1, 0}, 0.2, material2)
	append(&world.objects, Hittable{hit = sphere_hit, destroy = sphere_destroy, data = sphere2})

	material3 := new(Material)
	material3^ = Material {
		data    = metal_new(Color{0.7, 0.6, 0.5}, 0.0),
		scatter = metal_scatter,
	}

	sphere3 := sphere_new(Point3{-4, 1, 0}, 0.2, material3)
	append(&world.objects, Hittable{hit = sphere_hit, destroy = sphere_destroy, data = sphere3})

	camera := camera_new()

	ratio := 16.0 / 9.0
	image_width := 1200
	samples_per_pixel := 10 // 500 is high quality, but slow
	max_depth := 50
	fov := 20.0
	lookfrom := Point3{13, 2, 3}
	lookat := Point3{0, 0, 0}
	vup := Vec3{0, 1, 0}
	defocus_angle := 0.6
	focus_dist := 10.0

	camera_init(
		&camera,
		image_width,
		ratio,
		samples_per_pixel,
		max_depth,
		fov,
		lookfrom,
		lookat,
		vup,
		defocus_angle,
		focus_dist,
	)

	camera_render(&camera, "test_img.ppm", &world)

	// cleanup
	for hittable in world.objects {
		hittable.destroy(hittable.data)
	}
}
