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
	fmt.println("Book 1 - Raytracing in a weekend < WIP >")

	ratio := 16.0 / 9.0
	image_width := 800
	samples_per_pixel := 100
	max_depth := 50

	// Create the world
	world: HittableList

	// First material
	material_ground := new(Material)
	material_ground^ = Material {
		data    = lambertian_new(Color{0.8, 0.8, 0.0}),
		scatter = lambertian_scatter,
	}

	material_center := new(Material)
	material_center^ = Material {
		data    = lambertian_new(Color{0.1, 0.2, 0.5}),
		scatter = lambertian_scatter,
	}

	material_left := new(Material)
	material_left^ = Material {
		data    = metal_new(Color{0.8, 0.8, 0.8}, 0.3),
		scatter = metal_scatter,
	}

	material_right := new(Material)
	material_right^ = Material {
		data    = metal_new(Color{0.8, 0.6, 0.2}, 1.0),
		scatter = metal_scatter,
	}

	// TODO: We will attempt to delete the memory more than once here
	sphere1 := sphere_new(Vec3{0.0, -100.5, -1.0}, 100.0, material_ground)
	sphere2 := sphere_new(Vec3{0.0, 0.0, -1.2}, 0.5, material_center)
	sphere3 := sphere_new(Vec3{-1.0, 0.0, -1.0}, 0.5, material_left)
	sphere4 := sphere_new(Vec3{1.0, 0.0, -1.0}, 0.5, material_right)

	// TODO: THIS IS A POTENTIAL MEMORY ISSUE
	append(&world.objects, Hittable{hit = sphere_hit, destroy = sphere_destroy, data = sphere1})
	append(&world.objects, Hittable{hit = sphere_hit, destroy = sphere_destroy, data = sphere2})
	append(&world.objects, Hittable{hit = sphere_hit, destroy = sphere_destroy, data = sphere3})
	append(&world.objects, Hittable{hit = sphere_hit, destroy = sphere_destroy, data = sphere4})

	camera := camera_new()

	camera_init(&camera, image_width, ratio, samples_per_pixel, max_depth)
	camera_render(&camera, "test_img2.ppm", &world)

	// cleanup
	for hittable in world.objects {
		hittable.destroy(hittable.data)
	}
}
