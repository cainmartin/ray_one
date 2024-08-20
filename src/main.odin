package main

import "core:fmt"
import "core:os"
import "core:strings"

// TODO: I need to get a good example of file handling - THERE IS NO DOCUMENTATION!!
draw_ppm :: proc(width: int, height: int, filename: string) {
	// TODO: Separate functionality
	sb := strings.builder_make()

	// There has to be a better way to do this...
	strings.write_string(&sb, "P3\n")
	strings.write_int(&sb, width)
	strings.write_byte(&sb, ' ')
	strings.write_int(&sb, height)
	strings.write_string(&sb, "\n255\n")

	for row := 0; row < height; row += 1 {
		for col := 0; col < width; col += 1 {
			r := f32(col) / f32(width - 1)
			g := f32(row) / f32(height - 1)
			b := 0.0

			ir := int(255.99 * r)
			ig := int(255.99 * g)
			ib := int(255.99 * b)

			// TODO: Work out how to do this properlly
			strings.write_int(&sb, ir)
			strings.write_byte(&sb, ' ')
			strings.write_int(&sb, ig)
			strings.write_byte(&sb, ' ')
			strings.write_int(&sb, ib)
			strings.write_byte(&sb, '\n')
		}
	}
	// Convert the string builder content to a string
	content := strings.to_string(sb)

	// SAFELY transmute the string to a byte slice
	bytes := transmute([]u8)(content)

	// Write the content to the specified file
	os.write_entire_file(filename, bytes)

}

main :: proc() {
	fmt.println("Book 1 - Raytracing in a weekend")

	// First steps in the book - output a PPM image format
	draw_ppm(100, 100, "test_img.ppm")
}
