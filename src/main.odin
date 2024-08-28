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

Context :: struct {
	width:         int,
	height:        int,
	camera_center: Vec3,
	pixel_delta_u: Vec3,
	pixel_delta_v: Vec3,
	pixel00_loc:   Vec3,
}

draw_ppm :: proc(ctx: Context, filename: string) {
	fd, err := os.open(filename, os.O_CREATE | os.O_RDWR | os.O_TRUNC)
	defer os.close(fd)

	if err != os.ERROR_NONE {
		fmt.panicf("Error opening file: '%s' : %v", filename, err)
	}

	builder := strings.builder_make()
	defer strings.builder_destroy(&builder)

	// Write the header
	fmt.sbprintf(&builder, "P3\n%d %d\n255\n", ctx.width, ctx.height)

	for row := 0; row < ctx.height; row += 1 {
		fmt.printf("\rRendering row %d of %d", row + 1, ctx.height)
		for col := 0; col < ctx.width; col += 1 {

			pixel_center :=
				ctx.pixel00_loc + (f64(col) * ctx.pixel_delta_u) + (f64(row) * ctx.pixel_delta_v)
			ray_direction := pixel_center - ctx.camera_center
			r := ray_new(ctx.camera_center, ray_direction)
			pixel_color := ray_color(r)

			write_color(&builder, pixel_color)
		}
	}

	os.write_string(fd, strings.to_string(builder))
	fmt.println("\nRender complete.")
}

main :: proc() {
	fmt.println("Book 1 - Raytracing in a weekend")

	ratio := 16.0 / 9.0
	image_width := 800
	image_height := int(f64(image_width) / ratio)

	image_height = image_height < 1 ? 1 : image_height

	focal_length := 1.0
	viewport_height := 2.0
	viewport_width := viewport_height * (f64(image_width) / f64(image_height))
	camera_center := Vec3{0, 0, 0}
	// Calculate the vectors across the width / height
	viewport_u := Vec3{viewport_width, 0, 0}
	viewport_v := Vec3{0, -viewport_height, 0}

	// Calculate the delta vectors from pixel to pixel
	pixel_delta_u := viewport_u / f64(image_width)
	pixel_delta_v := viewport_v / f64(image_height)

	// Calculate the location of the upper left pixel
	viewport_upper_left :=
		camera_center - Vec3{0, 0, focal_length} - (viewport_u / 2) - (viewport_v / 2)
	pixel00_loc := viewport_upper_left + 0.5 * (pixel_delta_u + pixel_delta_v)

	ctx := Context {
		image_width,
		image_height,
		camera_center,
		pixel_delta_u,
		pixel_delta_v,
		pixel00_loc,
	}

	// First steps in the book - output a PPM image format
	draw_ppm(ctx, "test_img.ppm")
}
