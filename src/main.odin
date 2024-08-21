package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:os"
import "core:strings"

draw_ppm :: proc(width: int, height: int, filename: string) {
	fd, err := os.open(filename, os.O_CREATE | os.O_RDWR)
	defer os.close(fd)

	if err != os.ERROR_NONE {
		fmt.panicf("Error opening file: ", err)
	}

	// Write the header
	sb := fmt.tprintf("P3\n%d %d\n255\n", width, height)
	os.write_string(fd, sb)

	for row := 0; row < height; row += 1 {
		fmt.println("Rendering row: ", height - row)
		for col := 0; col < width; col += 1 {
			r := f32(col) / f32(width - 1)
			g := f32(row) / f32(height - 1)
			b := 0.0

			ir := int(255.99 * r)
			ig := int(255.99 * g)
			ib := int(255.99 * b)

			sb := fmt.tprintf("%d %d %d\n", ir, ig, ib)
			os.write_string(fd, sb)
		}
	}

	fmt.println("Completed.")
}

main :: proc() {
	fmt.println("Book 1 - Raytracing in a weekend")

	// First steps in the book - output a PPM image format
	draw_ppm(600, 600, "test_img.ppm")

	a := Vec3{1, 2, 3}
	b := a + 1

	c := linalg.vector_dot(a, b)

	fmt.println("Result: ", c)

}
