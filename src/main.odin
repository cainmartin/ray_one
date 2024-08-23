package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:os"
import "core:strings"

draw_ppm :: proc(width: int, height: int, filename: string) {
	fd, err := os.open(filename, os.O_CREATE | os.O_RDWR | os.O_TRUNC)
	defer os.close(fd)

	if err != os.ERROR_NONE {
		fmt.panicf("Error opening file: '%s' : %v", filename, err)
	}

	// Write the header
	header := fmt.tprintf("P3\n%d %d\n255\n", width, height)
	os.write_string(fd, header)

	// Buffer the writing
	builder := strings.builder_make()
	defer strings.builder_destroy(&builder)

	for row := height - 1; row >= 0; row -= 1 {
		fmt.printf("\rRendering row: %d", row)
		for col := 0; col < width; col += 1 {
			r := f32(col) / f32(width - 1)
			g := f32(row) / f32(height - 1)
			b := 0.0

			ir := int(255.99 * r)
			ig := int(255.99 * g)
			ib := int(255.99 * b)

			fmt.sbprintf(&builder, "%d %d %d\n", ir, ig, ib)
		}
	}

	os.write_string(fd, strings.to_string(builder))
	fmt.println("\nRender complete.")
}

main :: proc() {
	fmt.println("Book 1 - Raytracing in a weekend")

	// First steps in the book - output a PPM image format
	draw_ppm(640, 480, "test_img.ppm")
}
