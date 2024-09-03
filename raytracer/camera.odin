package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:os"
import "core:strings"

Camera :: struct {
	aspect_ratio:         f64,
	image_width:          int,
	samples_per_pixel:    int,
	max_depth:            int,
	vfov:                 f64,
	lookfrom:             Point3,
	lookat:               Point3,
	vup:                  Vec3,
	defocus_angle:        f64,
	focus_dist:           f64,
	_image_height:        int,
	_pixel_samples_scale: f64,
	_center:              Point3,
	_pixel00_loc:         Point3,
	_pixel_delta_u:       Vec3,
	_pixel_delta_v:       Vec3,
	_u:                   Vec3,
	_v:                   Vec3,
	_w:                   Vec3,
	_defocus_disk_u:      Vec3,
	_defocus_disk_v:      Vec3,
}

camera_new :: proc() -> Camera {
	return Camera {
		aspect_ratio = 1.0,
		image_width = 100,
		samples_per_pixel = 100,
		max_depth = 10,
		vfov = 90,
		lookfrom = Point3{-2, 2, 1},
		lookat = Point3{0, 0, -1},
		vup = Vec3{0, 1, 0},
		defocus_angle = 0,
		focus_dist = 10,
	}
}

camera_init :: proc(
	camera: ^Camera,
	width: int,
	ratio: f64,
	samples_per_pixel: int,
	max_depth: int,
	vfov: f64,
	lookfrom: Point3,
	lookat: Point3,
	vup: Vec3,
	defocus_angle: f64,
	focus_dist: f64,
) {
	camera.image_width = width
	camera.aspect_ratio = ratio
	camera.samples_per_pixel = samples_per_pixel
	camera.max_depth = max_depth
	camera.vfov = vfov
	camera.lookat = lookat
	camera.lookfrom = lookfrom
	camera.vup = vup
	camera.defocus_angle = defocus_angle
	camera.focus_dist = focus_dist

	camera._center = camera.lookfrom

	camera._image_height = int(f64(camera.image_width) / camera.aspect_ratio)
	camera._image_height = camera._image_height < 1 ? 1 : camera._image_height

	camera._pixel_samples_scale = 1.0 / f64(camera.samples_per_pixel)

	theta := degrees_to_radians(camera.vfov)
	h := math.tan(theta / 2.0)
	viewport_height := 2.0 * h * camera.focus_dist
	viewport_width := viewport_height * (f64(camera.image_width) / f64(camera._image_height))

	// Calculate the uvw unit basis vectors for the camera coordinate frame
	camera._w = vec3_normalize(camera.lookfrom - camera.lookat)
	camera._u = vec3_normalize(vec3_cross(camera.vup, camera._w))
	camera._v = vec3_cross(camera._w, camera._u)

	// Calculate the vectors across the width / height
	viewport_u := camera._u * viewport_width
	viewport_v := -camera._v * viewport_height // Vector down viewport vertical edge

	// Calculate the delta vectors from pixel to pixel
	camera._pixel_delta_u = viewport_u / f64(camera.image_width)
	camera._pixel_delta_v = viewport_v / f64(camera._image_height)

	// Calculate the location of the upper left pixel
	viewport_upper_left :=
		camera._center - (camera.focus_dist * camera._w) - (viewport_u / 2) - (viewport_v / 2)
	camera._pixel00_loc =
		viewport_upper_left + 0.5 * (camera._pixel_delta_u + camera._pixel_delta_v)

	defocus_radius := camera.focus_dist * math.tan(degrees_to_radians(camera.defocus_angle / 2.0))
	camera._defocus_disk_u = camera._u * defocus_radius
	camera._defocus_disk_v = camera._v * defocus_radius
}

camera_render :: proc(camera: ^Camera, filename: string, world: ^HittableList) {

	fd, err := os.open(filename, os.O_CREATE | os.O_RDWR | os.O_TRUNC, 0o664)
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

			pixel_color: Color = {0, 0, 0}

			for sample := 0; sample < camera.samples_per_pixel; sample += 1 {
				ray := get_ray(camera, col, row)
				pixel_color += ray_color(ray, camera.max_depth, world)
			}

			write_color(&builder, camera._pixel_samples_scale * pixel_color)
		}
	}

	os.write_string(fd, strings.to_string(builder))

	fmt.println("\nRender complete.")
}

get_ray :: proc(camera: ^Camera, col: int, row: int) -> Ray {
	// Construct a camera ray originating from the defocus disk and directed at a randomly
	// sampled point around the pixel location col, row.

	offset := sample_square()
	pixel_sample :=
		camera._pixel00_loc +
		((f64(col) + offset.x) * camera._pixel_delta_u) +
		((f64(row) + offset.y) * camera._pixel_delta_v)
	ray_origin := (camera.defocus_angle <= 0) ? camera._center : defocus_disk_sample(camera)
	ray_direction := pixel_sample - ray_origin

	return ray_new(ray_origin, ray_direction)
}

defocus_disk_sample :: proc(camera: ^Camera) -> Point3 {
	p := vec3_random_in_unit_disk()
	return camera._center + (p.x * camera._defocus_disk_u) + (p.y * camera._defocus_disk_v)
}

ray_color :: proc(r: Ray, depth: int, world: ^HittableList) -> Color {
	if depth <= 0 {
		return Color{0.0, 0.0, 0.0}
	}

	rec: HitRecord

	// TODO: make r more descriptive
	if process_hit(world, r, Interval{0.001, INFINITY}, &rec) {

		scattered := ray_new({0, 0, 0}, {0, 0, 0})
		attenuation := Color{0, 0, 0}
		if rec.material.scatter(rec.material.data, r, rec, &attenuation, &scattered) {
			return attenuation * ray_color(scattered, depth - 1, world)
		}
		return Color{0, 0, 0}
	}

	unit_direction := vec3_normalize(r.dir)
	a := 0.5 * unit_direction.y + 1.0

	return (a - 1.0) * Color{1.0, 1.0, 1.0} + a * Color{0.5, 0.7, 1.0}
}
