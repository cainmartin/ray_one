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

	// Create the world
	world: HittableList
	sphere1 := sphere_new(Vec3{0.0, 0.0, -1.0}, 0.5)
	sphere2 := sphere_new(Vec3{0.0, -100.5, -1.0}, 100.0)

	append(&world.objects, Hittable{hit = sphere_hit, data = &sphere1})
	append(&world.objects, Hittable{hit = sphere_hit, data = &sphere2})

	camera := camera_new()

	camera_init(&camera, image_width, ratio, samples_per_pixel)
	camera_render(&camera, "test_img.ppm", &world)
}
