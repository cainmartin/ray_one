package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:os"
import "core:strings"

Camera :: struct {
    aspect_ratio: f64,
    image_width: int,

    _image_height: int,
    _center: Point3,
    _pixel00_loc: Point3,
    _pixel_delta_u: Vec3,
    _pixel_delta_v: Vec3
}

camera_new :: proc() -> Camera {
    return Camera { aspect_ratio = 1.0, image_width = 100 }
}

camera_init :: proc(camera: ^Camera, width: int, ratio: f64) {
    camera.image_width = width
    camera.aspect_ratio = ratio

	camera._image_height = int(f64(camera.image_width) / camera.aspect_ratio)
	camera._image_height = camera._image_height < 1 ? 1 : camera._image_height

	focal_length := 1.0
	viewport_height := 2.0
	viewport_width := viewport_height * (f64(camera.image_width) / f64(camera._image_height))
	camera._center = Vec3{0, 0, 0}
	// Calculate the vectors across the width / height
	viewport_u := Vec3{viewport_width, 0, 0}
	viewport_v := Vec3{0, -viewport_height, 0}

	// Calculate the delta vectors from pixel to pixel
	camera._pixel_delta_u = viewport_u / f64(camera.image_width)
	camera._pixel_delta_v = viewport_v / f64(camera._image_height)

	// Calculate the location of the upper left pixel
	viewport_upper_left :=
		camera._center - Vec3{0, 0, focal_length} - (viewport_u / 2) - (viewport_v / 2)
	camera._pixel00_loc = viewport_upper_left + 0.5 * (camera._pixel_delta_u + camera._pixel_delta_v)
}

camera_render :: proc(camera: ^Camera, filename: string, world: ^HittableList) {

    fd, err := os.open(filename, os.O_CREATE | os.O_RDWR | os.O_TRUNC)
	defer os.close(fd)

	if err != os.ERROR_NONE {
		fmt.panicf("Error opening file: '%s' : %v", filename, err)
	}

	builder := strings.builder_make()
	defer strings.builder_destroy(&builder)

	// Write the header
	fmt.sbprintf(&builder, "P3\n%d %d\n255\n", camera.image_width, camera._image_height)

	for row := 0; row < camera._image_height; row += 1 {
		fmt.printf("\rRendering row %d of %d", row + 1, camera._image_height)
		for col := 0; col < camera.image_width; col += 1 {

			pixel_center :=
				camera._pixel00_loc + (f64(col) * camera._pixel_delta_u) + (f64(row) * camera._pixel_delta_v)
			ray_direction := pixel_center - camera._center
			r := ray_new(camera._center, ray_direction)
			pixel_color := ray_color(r, world)

			write_color(&builder, pixel_color)
		}
	}

	os.write_string(fd, strings.to_string(builder))
	fmt.println("\nRender complete.")
}


ray_color :: proc(r: Ray, world: ^HittableList) -> Color {
	rec: HitRecord

	if hit(world, r, Interval{0, INFINITY}, &rec) {
		return 0.5 * (rec.normal + Color{1, 1, 1})
	}

	unit_direction := vec3_normalize(r.dir)
	a := 0.5 * unit_direction.y + 1.0

	return (1.0 - a) * Color{1.0, 1.0, 1.0} + a * Color{0.5, 0.7, 1.0}
}