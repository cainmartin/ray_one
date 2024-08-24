package main

import "core:fmt"
import "core:strings"

Color :: Vec3

write_color :: proc(builder: ^strings.Builder, color: Color) {
	ir := int(255.99 * color.r)
	ig := int(255.99 * color.g)
	ib := int(255.99 * color.b)

	fmt.sbprintf(builder, "%d %d %d\n", ir, ig, ib)
}
